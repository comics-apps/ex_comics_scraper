defmodule Mix.Tasks.ComicVine.FetchElements do
  use Mix.Task

  @shortdoc "Fetch elements from ComicVine API"

  def run(args) do
    Mix.Task.run("app.start")
    number = args |> List.first |> String.to_integer
    ComicsScraper.ComicVine.FetchElements.call(number)
  end
end
