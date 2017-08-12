defmodule ComicsScraper.ComicVine.PrepareCollectionJobs do
  alias ComicsScraper.ComicVine.ApiModule
  alias ComicsScraper.Job
  alias ComicsScraper.Repo

  import ComicsScraper.ComicVine.Job, only: [collection_attrs: 2, collection_attrs: 4]
  import ComicsScraper.Utility, only: [merge_if: 3]

  def call(date \\ nil) do
    Enum.map(collections(), fn (resource) ->
      prepare_jobs(resource, date)
    end)
  end

  defp prepare_jobs(resource, date) do
    if date do
      prepare_jobs_with_date(resource, date, :date_added)
      prepare_jobs_with_date(resource, date, :date_last_updated)
    else
      prepare_jobs_without_date(resource)
    end
  end

  defp prepare_jobs_without_date(resource) do
    total_count = resource |> get_total_count
    pages = 0..round(total_count / 100) |> Enum.to_list

    Enum.each(pages, fn (page) ->
      attributes = collection_attrs(resource, page) |> Enum.into(%{})
      %Job{} |> Job.changeset(attributes) |> Repo.insert!
    end)
  end

  defp prepare_jobs_with_date(resource, date, date_field) do
    total_count = resource |> get_total_count(date, date_field)
    pages = 0..round(total_count / 100) |> Enum.to_list

    Enum.each(pages, fn (page) ->
      attributes = collection_attrs(resource, page, date, date_field)
        |> Enum.into(%{})
      %Job{} |> Job.changeset(attributes) |> Repo.insert!
    end)
  end

  defp get_total_count(resource, date \\ nil, date_type \\ nil) do
    extra_attrs = %{date_type => date} |> Map.to_list
    attrs = merge_if([limit: 1], date, extra_attrs)
    response = resource |> ApiModule.get |> apply(:all, [attrs])
    response["number_of_total_results"]
  end

  defp collections do
    [
      :characters, :concepts, :episodes, :issues, :locations, :movies, :objects,
      :origins, :people, :powers, :publishers, :series, :story_arcs, :teams,
      :volumes
    ]
  end
end
