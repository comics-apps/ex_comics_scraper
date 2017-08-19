defmodule ComicsScraper.Utility do
  def split_array_to_half(offset, limit) do
    list = offset..(offset + limit - 1) |> Enum.to_list
    len = round(length(list)/2)
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
    Regex.scan(~r/.{3}/, filled) |> List.flatten |> Enum.drop(-1)
      |> Enum.join("/")
  end

  def delete_job(job) do
    try do
      job |> ComicsScraper.Repo.delete
    rescue
      e -> nil
    end
  end
end
