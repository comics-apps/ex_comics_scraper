defmodule Mix.Tasks.Marvel.PrepareCollectionJobs do
  alias ComicsScraper.Marvel.PrepareCollectionJobs

  use Mix.Task

  @shortdoc "Prepare collection jobs for Marvel API"

  def run(_) do
    Mix.Task.run("app.start")
    PrepareCollectionJobs.call()
  end
end
