defmodule LunaTakeHomeWeb.OGImageLive.Show do
  use LunaTakeHomeWeb, :live_view
  alias LunaTakeHomeWeb.Util

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_, _, socket) do
    changeset = changeset(%{})
    og_image_request = %{url: nil}

    {:noreply,
     socket
     |> assign(
       page_title: "OG Image Viewer",
       changeset: changeset,
       og_image_request: og_image_request
     )}
  end

  @impl true
  def handle_event("get_og_image", %{"og_image_request" => params}, socket) do
    og_image_request = socket.assigns.og_image_request

    changeset = changeset(og_image_request, params)

    case Ecto.Changeset.apply_action(changeset, :update) do
      {:ok, _request} ->
        # TODO: get the og image
        {:noreply, assign(socket, :changeset, changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp changeset(%{} = request, params \\ %{}) do
    types = %{url: :string}

    {request, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required([:url])
    |> Util.validate_http_uri(:url)
  end
end
