defmodule Mix.Tasks.Marvel.FetchCollections do
  alias ComicsScraper.Marvel.FetchCollections

  use Mix.Task

  @shortdoc "Fetch collections from Marvel API"

  def run(_) do
    Mix.Task.run("app.start")
    FetchCollections.call()
  end
end
