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
end
