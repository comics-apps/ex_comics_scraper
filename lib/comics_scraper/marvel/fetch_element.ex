defmodule ComicsScraper.Marvel.FetchElement do
  import ComicsScraper.Utility, only: [partition: 1]

  def call(resource, id) do
    response = resource |> fetch_collection(id)
    if response["code"] == 200 do
      create_or_update_data(resource, response["data"]["results"] |> List.first)
    end
  end

  defp fetch_collection(resource, id) do
    :comics_scraper
      |> Application.get_env("marvel_api_" <> resource |> String.to_atom)
      |> apply(:get, [id])
  end

  defp create_or_update_data(resource, data) do
    id = data["resourceURI"] |> String.split("/") |> List.last
    path = Path.absname("data/marvel/" <> resource <> "/" <> partition(id) <>
      "/" <> id <> ".json")
    dir = path |> Path.dirname
    unless File.exists?(dir), do: File.mkdir_p(dir)
    File.write(path, Poison.encode!(data, pretty: true))
  end
end
