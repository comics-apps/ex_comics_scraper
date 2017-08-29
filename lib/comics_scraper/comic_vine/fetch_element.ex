defmodule ComicsScraper.ComicVine.FetchElement do
  alias ComicsScraper.ComicVine.Curl

  import ComicsScraper.Utility, only: [merge_if: 3, partition: 1]

  def timeout do
    180_000
  end

  def call(resource, id) do
    response = resource |> fetch_element(id |> String.to_integer, 0)
    resource |> create_or_update_data(id |> String.to_integer, response)
  end

  defp base_attrs(number) do
    num = number |> Integer.to_string
    [
      format: :json,
      api_key: System.get_env("COMIC_VINE_API_KEY_" <> num)
    ]
  end

  def fetch_and_save(resource, id, number) do
    response = resource |> fetch_element(id, number)
    resource |> create_or_update_data(id, response)
  end

  def fetch_element(resource, id, number) do
    attributes = number |> base_attrs
    num = number |> Integer.to_string
    options = merge_if(
      [timeout: timeout(), recv_timeout: timeout()],
      number > 0,
      [
        proxy: System.get_env("PROXY_" <> num),
        proxy_auth: {System.get_env("PROXY_USER_" <> num), System.get_env("PROXY_PASS_" <> num)}
      ]
    )
    resource |> Curl.element(id, attributes, options) |> Poison.decode!
  end

  defp create_or_update_data(resource, id, data) do
    id = id |> Integer.to_string
    path = Path.absname("data/comic_vine/" <> resource <> "/" <> partition(id) <>
      "/" <> id <> ".json")
    dir = path |> Path.dirname
    unless File.exists?(dir), do: File.mkdir_p(dir)
    File.write(path, Poison.encode!(data, pretty: true))
  end
end
