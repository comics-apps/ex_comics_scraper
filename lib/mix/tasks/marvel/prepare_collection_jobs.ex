defmodule Mix.Tasks.Marvel.PrepareCollectionJobs do
  use Mix.Task

  @shortdoc "Prepare collection jobs for Marvel API"

  def run(_) do
    Mix.Task.run("app.start")
    Dotenv.load
    ComicsScraper.Marvel.PrepareCollectionJobs.call()
  end
end