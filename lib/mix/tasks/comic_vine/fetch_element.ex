defmodule Mix.Tasks.ComicVine.FetchElement do
  alias ComicsScraper.ComicVine.FetchElement

  use Mix.Task

  @shortdoc "Fetch element from ComicVine API"

  def run(args) do
    Mix.Task.run("app.start")
    resource = args |> List.first
    id = args |> List.last
    FetchElement.call(resource, id)
  end
end
