defmodule ComicsScraper.Mixfile do
  use Mix.Project

  def project do
    [app: :comics_scraper,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      extra_applications: app_list(Mix.env),
      mod: {ComicsScraper.Application, []}
    ]
  end

  defp app_list(:dev), do: [:dotenv | app_list()]
  defp app_list(_), do: app_list()
  defp app_list, do: [:logger, :ecto, :postgrex]

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:dotenv, "~> 2.0.0"},
      {:postgrex, ">= 0.13.3"},
      {:ecto, "~> 2.1.6"},
      {:poison, "~> 3.1"},
      {:marvel_api, git: "https://github.com/comics-apps/ex_marvel_api.git"},
      {:comic_vine_api, git: "https://github.com/comics-apps/ex_comic_vine_api.git"}
    ]
  end
end
