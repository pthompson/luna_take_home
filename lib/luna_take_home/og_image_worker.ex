defmodule LunaTakeHome.OGImageWorker do
  @moduledoc """
  Background task to extract og image from web page
  """
  require Logger
  use Oban.Worker, queue: :og_image, max_attempts: 1
  alias LunaTakeHome.MetaExtractor

  @topic inspect(__MODULE__)

  def subscribe, do: Phoenix.PubSub.subscribe(LunaTakeHome.PubSub, @topic)

  def get_og_image(page_url) do
    __MODULE__.new(%{page_url: page_url})
    |> Oban.insert()
  end

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"page_url" => page_url}}) do
    MetaExtractor.get_og_image(page_url)
    |> notify_subscribers(page_url)
  end

  defp notify_subscribers({:ok, og_image_url}, page_url) do
    Phoenix.PubSub.broadcast(
      LunaTakeHome.PubSub,
      @topic,
      {__MODULE__, :ok, page_url, og_image_url}
    )

    {:ok, og_image_url}
  end

  defp notify_subscribers({:error, reason}, page_url) do
    Phoenix.PubSub.broadcast(LunaTakeHome.PubSub, @topic, {__MODULE__, :error, page_url, reason})
    {:error, reason}
  end
end
