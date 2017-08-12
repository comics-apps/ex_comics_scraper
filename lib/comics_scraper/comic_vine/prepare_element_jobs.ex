defmodule ComicsScraper.ComicVine.PrepareElementJobs do
  alias ComicsScraper.ComicVine.ApiModule
  alias ComicsScraper.Job
  alias ComicsScraper.Repo

  import ComicsScraper.ComicVine.Job, only: [element_attrs: 2]
  import ComicsScraper.Utility, only: [merge_if: 3]
  import Ecto.Query

  def timeout do
    180000
  end

  def call do
    case find_job() do
      nil ->
        "Nothing to do"
      job ->
        IO.inspect(job)
        fetch_and_prepare_jobs(job)
        job |> Repo.delete
        :timer.sleep(1000)
        call()
    end
  end

  def find_job do
    query = from j in Job,
      where:  j.type == "comic_vine_collection" and j.priority == 1,
      order_by: fragment("RANDOM()"),
      limit: 1
    query |> Repo.one
  end

  def fetch_and_prepare_jobs(job) do
    settings = job.settings
    fetch_and_prepare(settings["collection"], 100, settings["offset"],
      settings["date"], settings["date_field"])
  end

  defp base_attrs(limit, offset) do
    [limit: limit, offset: offset, sort: :id]
  end

  def fetch_and_prepare(resource, limit, offset, date, date_field) do
    response = resource |> fetch_collection(limit, offset, date, date_field)
    response["results"] |> Enum.each(fn(data) ->
      resource |> prepare_element_job(data)
    end)
  end

  def fetch_collection(resource, limit, offset, date, date_field) do
    extra_attrs = %{date_field => date} |> Map.to_list
    attrs = merge_if(base_attrs(limit, offset), date, extra_attrs)
    options = [timeout: timeout(), recv_timeout: timeout()]
    resource |> String.to_atom |> ApiModule.get |> apply(:all, [attrs, options])
  end

  defp prepare_element_job(resource, data) do
    attributes = element_attrs(resource, data)
      |> Enum.into(%{})
    %Job{} |> Job.changeset(attributes) |> Repo.insert!
  end
end