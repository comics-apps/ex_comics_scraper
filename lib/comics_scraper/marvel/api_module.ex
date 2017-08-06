defmodule ComicsScraper.Marvel.ApiModule do
  def get(resource) do
    case resource do
      :characters ->
        MarvelApi.Characters
      :comics ->
        MarvelApi.Comics
      :creators ->
        MarvelApi.Creators
      :events ->
        MarvelApi.Events
      :series ->
        MarvelApi.Series
      :stories ->
        MarvelApi.Stories
    end
  end
end
