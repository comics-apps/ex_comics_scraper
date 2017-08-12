defmodule ComicsScraper.ComicVine.ApiModule do
  def get(resource) do
    case resource do
      :characters ->
        ComicVineApi.Characters
      :concepts ->
        ComicVineApi.Concepts
      :episodes ->
        ComicVineApi.Episodes
      :issues ->
        ComicVineApi.Issues
      :locations ->
        ComicVineApi.Locations
      :movies ->
        ComicVineApi.Movies
      :objects ->
        ComicVineApi.Objects
      :origins ->
        ComicVineApi.Origins
      :people ->
        ComicVineApi.People
      :powers ->
        ComicVineApi.Powers
      :publishers ->
        ComicVineApi.Publishers
      :series ->
        ComicVineApi.Series
      :story_arcs ->
        ComicVineApi.StoryArcs
      :teams ->
        ComicVineApi.Teams
      :volumes ->
        ComicVineApi.Volumes
    end
  end
end
