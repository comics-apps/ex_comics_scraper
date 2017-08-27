defmodule ComicsScraper.ComicVine.Curl do
  def collection(resource, attributes, options) do
    query_params = URI.encode_query(attributes)
    proxy_options = if options[:proxy] do
      proxy_auth = options[:proxy_auth] |> Tuple.to_list |> Enum.join(":")
      ["--proxy", options[:proxy], "--proxy-user", proxy_auth]
    else
      []
    end

    case System.cmd "curl", proxy_options ++ ["-s", "https://comicvine.gamespot.com/api/" <> resource <> "/?" <> query_params]  do
      {output, 0} ->  output
      {err, code} -> {:error, [message: err, code: code]}
    end
  end

  def element(resource, id, attributes, options) do
    fields = field_list(resource)
    attributes = case fields do
      "" -> attributes
      _  -> Enum.concat([field_list: fields], attributes)
    end
    query_params = URI.encode_query(attributes)
    proxy_options = if options[:proxy] do
      proxy_auth = options[:proxy_auth] |> Tuple.to_list |> Enum.join(":")
      ["--proxy", options[:proxy], "--proxy-user", proxy_auth]
    else
      []
    end

    element_resource = resource |> find_element_resource
    id_prefix = resource |> find_element_id_prefix |> Integer.to_string
    id = id |> Integer.to_string

    case System.cmd "curl", proxy_options ++ ["-s", "https://comicvine.gamespot.com/api/" <> element_resource <> "/" <> id_prefix <> "-" <> id <> "/?" <> query_params]  do
      {output, 0} ->  output
      {err, code} -> {:error, [message: err, code: code]}
    end
  end

  defp find_element_resource(resource) do
    case resource do
      "characters" -> "character"
      "concepts"   -> "concept"
      "episodes"   -> "episode"
      "issues"     -> "issue"
      "locations"  -> "location"
      "movies"     -> "movie"
      "objects"    -> "object"
      "origins"    -> "origin"
      "people"     -> "person"
      "powers"     -> "power"
      "publishers" -> "publisher"
      "series"     -> "series"
      "story_arcs" -> "story_arc"
      "teams"      -> "team"
      "volumes"    -> "volume"
    end
  end

  defp find_element_id_prefix(resource) do
    case resource do
      "characters" -> 4005
      "concepts"   -> 4015
      "episodes"   -> 4070
      "issues"     -> 4000
      "locations"  -> 4020
      "movies"     -> 4025
      "objects"    -> 4055
      "origins"    -> 4030
      "people"     -> 4040
      "powers"     -> 4035
      "publishers" -> 4010
      "series"     -> 4075
      "story_arcs" -> 4045
      "teams"      -> 4060
      "volumes"    -> 4050
    end
  end

  defp field_list(resource) do
    case resource do
      "locations"  ->
        [
          :aliases, :api_detail_url, :count_of_isssue_appearances, :date_added, :date_last_updated, :deck, :description,
          :first_appeared_in_issue, :id, :image, :movies, :name, :site_detail_url, :start_year
        ]
      "movies"     ->
        [
          :api_detail_url, :box_office_revenue, :budget, :characters, :concepts, :date_added, :date_last_updated, :deck,
          :description, :distributor, :id, :image, :locations, :name, :producers, :rating, :release_date, :runtime,
          :site_detail_url, :studios, :teams, :things, :total_revenue, :writers
        ]
      "origins"    ->
        [
          :api_detail_url, :id, :name, :profiles, :site_detail_url
        ]
      _            -> []
    end |> Enum.map(fn(x) -> x |> Atom.to_string end) |> Enum.join(",")
  end
end
