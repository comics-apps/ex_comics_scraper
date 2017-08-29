defmodule ComicsScraper.Marvel.Check do
  alias ComicsScraper.Marvel.FetchElement

  import ComicsScraper.Utility, only: [partition: 1]

  def call do
    resources()
    |> Enum.each(fn(resource) ->
         "./data/marvel/" <> resource
         |> FileExt.ls_r
         |> Enum.each(fn(path) -> resource |> each_scrapped_file(path) end)
       end)
  end

  defp each_scrapped_file(resource, path) do
    {:ok, content} = File.read(path)
    content = Poison.decode!(content)
    resource
    |> relations
    |> Enum.each(fn(rel) -> resource |> each_elements(rel, content) end)
  end

  defp each_elements(resource, rel, content) do
    content[rel]["items"]
      |> Enum.each(fn(y) -> resource |> conditionally_download(rel, y) end)
  end

  defp conditionally_download(resource, rel, entity) do
    id = entity["resourceURI"] |> String.split("/") |> List.last
    path = "./data/marvel/" <> rel <> "/" <> partition(id) <> "/" <> id <> ".json"
    if !File.exists?(path) do
      IO.puts(resource <> "/" <> rel <> ": #" <> id)
      IO.puts(entity["resourceURI"])
      FetchElement.call(rel, id)
    end
  end

  defp resources do
    Application.get_env(:comics_scraper, :marvel_collections)
  end

  defp relations(resource) do
    sub_field = "marvel_rel_" <> resource |> String.to_atom
    Application.get_env(:comics_scraper, sub_field)
  end
end
