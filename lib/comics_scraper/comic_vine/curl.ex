defmodule ComicsScraper.ComicVine.Curl do
  def collection(resource, attributes, options) do
    query_params = URI.encode_query(attributes)
    proxy_options = if options[:proxy] do
      proxy_auth = options[:proxy_auth] |> Tuple.to_list |> Enum.join(":")
      ["--proxy", options[:proxy], "--proxy-user", proxy_auth]
    else
      []
    end

    options = [
      "-s",
      "https://comicvine.gamespot.com/api/" <> resource <> "/?" <> query_params
    ]
    case System.cmd "curl", proxy_options ++ options do
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

    options = [
      "-s",
      "https://comicvine.gamespot.com/api/" <> element_resource <> "/" <>
        id_prefix <> "-" <> id <> "/?" <> query_params
    ]
    case System.cmd "curl", proxy_options ++ options do
      {output, 0} ->  output
      {err, code} -> {:error, [message: err, code: code]}
    end
  end

  defp find_element_resource(resource) do
    case resource do
      "series" -> "series"
      _        -> resource |> Inflex.singularize
    end
  end

  defp find_element_id_prefix(resource) do
    subkey = "cv_id_prefix_" <> resource |> String.to_atom
    Application.get_env(:comics_scraper, subkey)
  end

  defp field_list(resource) do
    field = :comics_scraper
    fields = case resource do
      "characters" -> Application.get_env(field, :cv_fields_characters)
      "concepts"   -> Application.get_env(field, :cv_fields_concepts)
      "locations"  -> Application.get_env(field, :cv_fields_locations)
      "movies"     -> Application.get_env(field, :cv_fields_movies)
      "origins"    -> Application.get_env(field, :cv_fields_origins)
      "teams"      -> Application.get_env(field, :cv_fields_teams)
      _            -> []
    end
    fields |> Enum.map(fn(x) -> x |> Atom.to_string end) |> Enum.join(",")
  end
end
