defmodule LunaTakeHome.MetaExtractor do
  @moduledoc """
  Functions to extract meta data from web pages.
  """

  @doc """
  Get og:image from web page meta element.

  ## Parameters

    - url: URL string of the target web page

  ## Examples

      iex> LunaTakeHome.MetaExtractor.get_og_image("https://www.getluna.com/")
      {:ok, "https://public-images.getluna.com/images/social/facebook.png"}

  """
  @spec get_og_image(String.t()) ::
          {:error, String.t()} | {:ok, String.t()}
  def get_og_image(page_url) do
    get_meta_content_for_property(page_url, "og:image")
  end

  @spec get_meta_content_for_property(String.t(), String.t()) ::
          {:error, String.t()} | {:ok, String.t()}
  defp get_meta_content_for_property(url, property) do
    # Returns value of content attribute for meta element with given property attribute.
    # This could be generalized to handle other types of meta elements, but for now it is
    # good enough.
    case get_document(url) do
      {:ok, html} ->
        get_meta_property_content(html, property)

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp get_document(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body}

      _ ->
        {:error, "could not access url"}
    end
  end

  defp get_meta_property_content(html, property) do
    case Floki.parse_document(html) do
      {:ok, document} ->
        document
        |> Floki.find("meta")
        |> Floki.find("[property='#{property}']")
        |> Floki.attribute("content")
        |> format_result(property)

      _ ->
        {:error, "page does not contain meta property '#{property}'"}
    end
  end

  defp format_result(list, _property) when is_list(list) and length(list) >= 1,
    do: {:ok, hd(list)}

  defp format_result(_, property),
    do: {:error, "page does not contain meta property '#{property}'"}
end
