defmodule Mix.Tasks.ComicVine.PrepareCollectionJobs do
  alias ComicsScraper.ComicVine.PrepareCollectionJobs

  use Mix.Task

  @shortdoc "Prepare collection jobs for ComicVine API"

  def run(_) do
    Mix.Task.run("app.start")
    PrepareCollectionJobs.call()
  end
end
