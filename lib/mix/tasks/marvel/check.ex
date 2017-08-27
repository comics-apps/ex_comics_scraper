defmodule Mix.Tasks.Marvel.Check do
  use Mix.Task

  @shortdoc "Checking all scrapped resources"

  def run(_) do
    Mix.Task.run("app.start")
    ComicsScraper.Marvel.Check.call()
  end
end
