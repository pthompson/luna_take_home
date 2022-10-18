defmodule LunaTakeHomeWeb.OGImageLive.Show do
  use LunaTakeHomeWeb, :live_view
  alias LunaTakeHome.OGImageWorker
  alias LunaTakeHomeWeb.Util

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      OGImageWorker.subscribe()
    end

    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket) do
    changeset = changeset(%{})

    {:noreply,
     socket
     |> assign(
       page_title: "OG Image Viewer",
       changeset: changeset,
       url: nil,
       og_image_url: nil,
       fetching?: false,
       fetch_error: nil
     )}
  end

  @impl true
  def handle_event("get_og_image", %{"og_image_request" => params}, socket) do
    changeset = changeset(%{}, params)

    case Ecto.Changeset.apply_action(changeset, :update) do
      {:ok, _request} ->
        url = changeset.changes.url
        OGImageWorker.get_og_image(url)

        {:noreply,
         assign(socket,
           changeset: changeset,
           url: url,
           og_image_url: nil,
           fetching?: true,
           fetch_error: nil
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         assign(socket,
           changeset: changeset,
           url: nil,
           og_image_url: nil,
           fetching?: false,
           fetch_error: nil
         )}
    end
  end

  @impl Phoenix.LiveView
  # Handle pubsub event with result of get_og_image/1 call to OGImageWorker.
  # Filter by url.
  def handle_info(
        {LunaTakeHome.OGImageWorker, :ok, url, og_image_url},
        %{assigns: %{url: url, fetching?: true}} = socket
      ) do
    {:noreply, assign(socket, og_image_url: og_image_url, fetch_error: nil, fetching?: false)}
  end

  def handle_info(
        {LunaTakeHome.OGImageWorker, :error, url, reason},
        %{assigns: %{url: url, fetching?: true}} = socket
      ) do
    {:noreply, assign(socket, fetch_error: reason, og_image_url: nil, fetching?: false)}
  end

  # Ignore other messages
  def handle_info(_message, socket) do
    {:noreply, socket}
  end

  # Schemaless changeset
  defp changeset(%{} = request, params \\ %{}) do
    types = %{url: :string}

    {request, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required([:url])
    |> Util.validate_http_uri(:url)
  end
end
