defmodule Mix.Tasks.ComicVine.PrepareCollectionJobs do
  use Mix.Task

  @shortdoc "Prepare collection jobs for ComicVine API"

  def run(_) do
    Mix.Task.run("app.start")
    Dotenv.load
    ComicsScraper.ComicVine.PrepareCollectionJobs.call()
  end
end