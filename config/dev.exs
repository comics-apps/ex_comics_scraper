use Mix.Config

config :comics_scraper, ComicsScraper.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "comics_scraper_dev",
  hostname: "localhost"
