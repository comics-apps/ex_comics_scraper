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
end
