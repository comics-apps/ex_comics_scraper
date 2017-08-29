defmodule ComicsScraper.Marvel.FetchCollections do
  alias ComicsScraper.Job
  alias ComicsScraper.Repo

  import ComicsScraper.Utility,
    only: [split_array_to_half: 2, merge_if: 3, partition: 1, delete_job: 1]
  import Ecto.Query

  def timeout do
    180_000
  end

  def call do
    case find_job() do
      nil ->
        "Nothing to do"
      job ->
        fetch_and_save_from_job(job)
        job |> delete_job
        call()
    end
  end

  def find_job do
    query = from j in Job,
      where:  j.type == "marvel" and j.priority == 1,
      order_by: fragment("RANDOM()"),
      limit: 1
    query |> Repo.one
  end

  def fetch_and_save_from_job(job) do
    settings = job.settings
    fetch_and_save(settings["collection"], 100, settings["offset"],
      settings["date"])
  end

  def fetch_and_save(resource, limit, offset, date) do
    response = resource |> fetch_collection(limit, offset, date)
    response["data"]["results"] |> Enum.each(fn(data) ->
      resource |> create_or_update_data(data)
    end)
  rescue
    _ ->
      handle_exception(resource, limit, offset, date)
  end

  defp base_attrs(resource, limit, offset) do
    order_by = :comics_scraper
      |> Application.get_env("marvel_order_by_" <> resource |> String.to_atom)
    [limit: limit, offset: offset, orderBy: order_by]
  end

  defp fetch_collection(resource, limit, offset, date) do
    attrs = merge_if(base_attrs(resource, limit, offset), date,
                     [modifiedSince: date])
    options = [timeout: timeout(), recv_timeout: timeout()]
    :comics_scraper
      |> Application.get_env("marvel_api_" <> resource |> String.to_atom)
      |> apply(:all, [attrs, options])
  end

  def handle_exception(resource, limit, offset, date) do
    case limit do
      1 ->
        IO.puts("Cannot handle exception for " <> resource <> ", offset: "
                <> offset <> ", limit: " <> limit)
      _ ->
        {left, right} = split_array_to_half(offset, limit)
        fetch_and_save(resource, length(left), List.first(left), date)
        fetch_and_save(resource, length(right), List.first(right), date)
    end
  end

  defp create_or_update_data(resource, data) do
    id = data["resourceURI"] |> String.split("/") |> List.last
    path = Path.absname("data/marvel/" <> resource <> "/" <> partition(id) <>
      "/" <> id <> ".json")
    dir = path |> Path.dirname
    unless File.exists?(dir), do: File.mkdir_p(dir)
    File.write(path, Poison.encode!(data, pretty: true))
  end
end
