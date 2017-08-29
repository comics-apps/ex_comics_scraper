defmodule ComicsScraper.ComicVine.PrepareElementJobs do
  alias ComicsScraper.ComicVine.Curl
  alias ComicsScraper.Job
  alias ComicsScraper.Repo

  import ComicsScraper.ComicVine.Job, only: [element_attrs: 2]
  import ComicsScraper.Utility, only: [merge_if: 3, delete_job: 1]
  import Ecto.Query

  def timeout do
    180_000
  end

  def call(number \\ 0) do
    case find_job() do
      nil ->
        "Nothing to do"
      job ->
        fetch_and_prepare_jobs(job, number)
        job |> delete_job
        :timer.sleep(1000)
        call(number)
    end
  end

  def find_job do
    query = from j in Job,
      where:  j.type == "comic_vine_collection" and j.priority == 1,
      order_by: fragment("RANDOM()"),
      limit: 1
    query |> Repo.one
  end

  def fetch_and_prepare_jobs(job, number) do
    settings = job.settings
    fetch_and_prepare(settings["collection"], %{limit: 100, offset: settings["offset"]},
      settings["date"], settings["date_field"], number)
  end

  defp base_attrs(limit, offset, number) do
    num = number |> Integer.to_string
    [
      limit: limit, offset: offset, sort: :id, format: :json,
      api_key: System.get_env("COMIC_VINE_API_KEY_" <> num),
      field_list: "id"
    ]
  end

  def fetch_and_prepare(resource, options, date, date_field, number) do
    response = resource
      |> fetch_collection(options, date, date_field, number)
    response["results"] |> Enum.each(fn(data) ->
      resource |> prepare_element_job(data)
    end)
  end

  def fetch_collection(resource, options, date, date_field, number) do
    extra_attrs = %{date_field => date} |> Map.to_list
    attrs = merge_if(
      base_attrs(options[:limit], options[:offset], number),
      date, extra_attrs
    )
    num = number |> Integer.to_string
    options = merge_if(
      [timeout: timeout(), recv_timeout: timeout()],
      number > 0,
      [
        proxy: System.get_env("PROXY_" <> num),
        proxy_auth: {System.get_env("PROXY_USER_" <> num), System.get_env("PROXY_PASS_" <> num)}
      ]
    )
    resource |> Curl.collection(attrs, options) |> Poison.decode!
  end

  defp prepare_element_job(resource, data) do
    attributes = resource
      |> element_attrs(data)
      |> Enum.into(%{})
    %Job{} |> Job.changeset(attributes) |> Repo.insert!
  end
end
