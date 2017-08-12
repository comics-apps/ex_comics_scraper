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
end
