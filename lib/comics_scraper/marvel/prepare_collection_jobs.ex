defmodule ComicsScraper.Marvel.PrepareCollectionJobs do
  alias ComicsScraper.Job
  alias ComicsScraper.Repo

  import ComicsScraper.Marvel.Job, only: [collection_attrs: 3]
  import ComicsScraper.Utility, only: [merge_if: 3]

  def call(date \\ nil) do
    Enum.map(collections(), fn (resource) ->
      prepare_jobs(resource, date)
    end)
  end

  defp prepare_jobs(resource, date) do
    total_count = resource |> get_total_count(date)
    pages = 0..round(total_count / 100) |> Enum.to_list

    Enum.each(pages, fn (page) ->
      attributes = resource |> collection_attrs(date, page) |> Enum.into(%{})
      %Job{} |> Job.changeset(attributes) |> Repo.insert!
    end)
  end

  defp get_total_count(resource, date) do
    attrs = merge_if([limit: 1], date, [modifiedSince: date])
    response = :comics_scraper
      |> Application.get_env("marvel_api_" <> resource |> String.to_atom)
      |> apply(:all, [attrs])
    response["data"]["total"]
  end

  defp collections do
    Application.get_env(:comics_scraper, :marvel_collections)
  end
end
