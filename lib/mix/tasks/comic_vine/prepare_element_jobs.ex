defmodule Mix.Tasks.ComicVine.PrepareElementJobs do
  alias ComicsScraper.ComicVine.PrepareElementJobs

  use Mix.Task

  @shortdoc "Prepare element jobs for ComicVine API"

  def run(args) do
    Mix.Task.run("app.start")
    number = args |> List.first |> String.to_integer
    PrepareElementJobs.call(number)
  end
end
