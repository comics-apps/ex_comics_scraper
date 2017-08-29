defmodule Mix.Tasks.Marvel.Check do
  alias ComicsScraper.Marvel.Check

  use Mix.Task

  @shortdoc "Checking all scrapped resources"

  def run(_) do
    Mix.Task.run("app.start")
    Check.call()
  end
end
