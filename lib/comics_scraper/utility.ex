defmodule ComicsScraper.Utility do
  alias ComicsScraper.Repo

  def split_array_to_half(offset, limit) do
    list = offset..(offset + limit - 1) |> Enum.to_list
    len = round(length(list) / 2)
    Enum.split(list, len)
  end

  def merge_if(base_attrs, condition, extra_attrs) do
    if condition do
      Enum.concat(extra_attrs, base_attrs)
    else
      base_attrs
    end
  end

  def partition(value) do
    filled = value |> String.pad_leading(9, "0")
    ~r/.{3}/
      |> Regex.scan(filled)
      |> List.flatten
      |> Enum.drop(-1)
      |> Enum.join("/")
  end

  def delete_job(job) do
    job |> Repo.delete
  rescue
    _ -> nil
  end
end
