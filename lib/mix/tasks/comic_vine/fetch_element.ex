defmodule Mix.Tasks.ComicVine.FetchElement do
  use Mix.Task

  @shortdoc "Fetch element from ComicVine API"

  def run(args) do
    Mix.Task.run("app.start")
    resource = args |> List.first
    id = args |> List.last
    ComicsScraper.ComicVine.FetchElement.call(resource, id)
  end
end
