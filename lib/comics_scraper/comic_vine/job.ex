defmodule ComicsScraper.ComicVine.Job do
  def collection_attrs(resource, page, date \\ nil, date_field \\ nil) do
    [
      type: "comic_vine_collection",
      priority: 1,
      settings: %{
        collection: resource,
        offset: page * 100,
        date: date,
        date_field: date_field
      }
    ]
  end

  def element_attrs(resource, data) do
    [
      type: "comic_vine_element",
      priority: 2,
      settings: %{
        collection: resource,
        id: data["id"]
      }
    ]
  end
end
