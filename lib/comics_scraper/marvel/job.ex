defmodule ComicsScraper.Marvel.Job do
  def collection_attrs(resource, date, page) do
    [
      type: "marvel",
      priority: 1,
      settings: %{
        collection: resource,
        offset: page * 100,
        date: date
      }
    ]
  end
end
