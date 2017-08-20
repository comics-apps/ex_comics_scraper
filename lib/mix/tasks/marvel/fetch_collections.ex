defmodule Mix.Tasks.Marvel.FetchCollections do
  use Mix.Task

  @shortdoc "Fetch collections from Marvel API"

  def run(_) do
    Mix.Task.run("app.start")
    ComicsScraper.Marvel.FetchCollections.call()
  end
end
