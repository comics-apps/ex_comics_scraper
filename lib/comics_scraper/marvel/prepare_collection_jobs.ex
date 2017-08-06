defmodule ComicsScraper.Marvel.PrepareCollectionJobs do
  alias ComicsScraper.Job
  alias ComicsScraper.Marvel.ApiModule
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
      attributes = collection_attrs(resource, date, page) |> Enum.into(%{})
      %Job{} |> Job.changeset(attributes) |> Repo.insert!
    end)
  end

  defp get_total_count(resource, date) do
    attrs = merge_if([limit: 1], date, [modifiedSince: date])
    response = resource |> ApiModule.get |> apply(:all, [attrs])
    response["data"]["total"]
  end

  defp collections do
    [:characters, :comics, :creators, :events, :series, :stories]
  end
end
