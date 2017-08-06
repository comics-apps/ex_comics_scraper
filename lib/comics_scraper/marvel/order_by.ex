defmodule ComicsScraper.Marvel.OrderBy do
  def order_by(resource) do
    case resource do
      "characters" ->
        "modified,name"
      "comics" ->
        "onsaleDate,title"
      "creators" ->
        "modified,lastName,firstName,middleName"
      "events" ->
        "modified,name"
      "series" ->
        "startYear,title"
      "stories" ->
        "modified,id"
    end
  end
end
