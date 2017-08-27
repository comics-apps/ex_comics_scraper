defmodule ComicsScraper.Marvel.Check do
  import ComicsScraper.Utility, only: [partition: 1]

  def call do
    resources()
    |> Enum.each(fn(resource) ->
         FileExt.ls_r("./data/marvel/" <> resource)
         |> Enum.each(fn(x) ->
              {:ok, content} = File.read(x)
              content = Poison.decode!(content)
              resource
              |> relations
              |> Enum.each(fn(rel) ->
                   items = content[rel]["items"]
                   items
                   |> Enum.each(fn(y) ->
                        id = y["resourceURI"] |> String.split("/") |> List.last
                        path = "./data/marvel/" <> rel <> "/" <> partition(id) <> "/" <> id <> ".json"
                        if !File.exists?(path) do
                          IO.puts(resource <> "/" <> rel <> ": #" <> id)
                          IO.puts(y["resourceURI"])
                          ComicsScraper.Marvel.FetchElement.call(rel, id)
                        end
                      end)
                 end)
            end)
       end)
  end

  defp resources do
    ["characters", "comics", "creators", "events", "series", "stories"]
  end

  defp relations(resource) do
    case resource do
      "characters" ->
        ["stories", "series", "events", "comics"]
      "comics" ->
        ["stories", "events", "creators", "characters"]
      "creators" ->
        ["stories", "series", "events", "comics"]
      "events" ->
        ["stories", "series", "creators", "comics", "characters"]
      "series" ->
        ["stories", "events", "creators", "comics", "characters"]
      "stories" ->
        ["series", "events", "creators", "comics", "characters"]
    end
  end
end
