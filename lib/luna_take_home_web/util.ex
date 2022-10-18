defmodule LunaTakeHomeWeb.Util do
  @moduledoc false

  @doc """
  Custom changeset validator to validate format of url

  If url is valid then changeset is returned unchanged. If there is an
  error then error is added to changeset and changeset is returned.

  ## Examples

      iex> validate_http_uri(changeset, :field_name)
      %Ecto.Changeset{}

  """
  @spec validate_http_uri(Ecto.Changeset.t(), atom) :: Ecto.Changeset.t()
  def validate_http_uri(changeset, uri_field) do
    case Ecto.Changeset.fetch_field(changeset, uri_field) do
      :error ->
        changeset

      {_, uri_value} ->
        if uri_value != nil do
          case is_valid_http_uri(uri_value) do
            {:ok, _} ->
              changeset

            {:error, message} ->
              Ecto.Changeset.add_error(changeset, uri_field, message)
          end
        else
          changeset
        end
    end
  end

  defp is_valid_http_uri(url) do
    uri = URI.parse(url)

    cond do
      !(uri.scheme in ~w(http https)) ->
        {:error, "must start with 'http' or 'https'"}

      uri.host == nil || !LunaTakeHome.ValidUrl.validate(url) ->
        {:error, "format invalid"}

      true ->
        {:ok, url}
    end
  end
end
