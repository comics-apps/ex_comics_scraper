# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :comics_scraper,
  ecto_repos: [ComicsScraper.Repo],
  cv_api_characters: ComicVineApi.Characters,
  cv_api_concepts: ComicVineApi.Concepts,
  cv_api_episodes: ComicVineApi.Episodes,
  cv_api_issues: ComicVineApi.Issues,
  cv_api_locations: ComicVineApi.Locations,
  cv_api_movies: ComicVineApi.Movies,
  cv_api_objects: ComicVineApi.Objects,
  cv_api_origins: ComicVineApi.Origins,
  cv_api_people: ComicVineApi.People,
  cv_api_powers: ComicVineApi.Powers,
  cv_api_publishers: ComicVineApi.Publishers,
  cv_api_series: ComicVineApi.Series,
  cv_api_story_arcs: ComicVineApi.StoryArcs,
  cv_api_teams: ComicVineApi.Teams,
  cv_api_volumes: ComicVineApi.Volumes,
  cv_id_prefix_characters: 4005,
  cv_id_prefix_concepts: 4015,
  cv_id_prefix_episodes: 4070,
  cv_id_prefix_issues: 4000,
  cv_id_prefix_locations: 4020,
  cv_id_prefix_movies: 4025,
  cv_id_prefix_objects: 4055,
  cv_id_prefix_origins: 4030,
  cv_id_prefix_people: 4040,
  cv_id_prefix_powers: 4035,
  cv_id_prefix_publishers: 4010,
  cv_id_prefix_series: 4075,
  cv_id_prefix_story_arcs: 4045,
  cv_id_prefix_teams: 4060,
  cv_id_prefix_volumes: 4050,
  cv_fields_characters: [
    :aliases, :api_detail_url, :birth, :character_enemies, :character_friends,
    :count_of_issue_appearances, :creators, :date_added, :date_last_updated,
    :deck, :description, :first_appeared_in_issue, :gender, :id, :image,
    :movies, :name, :origin, :powers, :publisher, :real_name, :site_detail_url,
    :team_enemies, :team_friends, :teams
  ],
  cv_fields_concepts: [
    :aliases, :api_detail_url, :count_of_isssue_appearances, :date_added,
    :date_last_updated, :deck, :description, :first_appeared_in_issue, :id,
    :image, :movies, :name, :site_detail_url, :start_year
  ],
  cv_fields_locations: [
    :aliases, :api_detail_url, :count_of_isssue_appearances, :date_added,
    :date_last_updated, :deck, :description, :first_appeared_in_issue, :id,
    :image, :movies, :name, :site_detail_url, :start_year
  ],
  cv_fields_movies: [
    :api_detail_url, :box_office_revenue, :budget, :characters, :concepts,
    :date_added, :date_last_updated, :deck, :description, :distributor, :id,
    :image, :locations, :name, :producers, :rating, :release_date, :runtime,
    :site_detail_url, :studios, :teams, :things, :total_revenue, :writers
  ],
  cv_fields_origins: [
    :api_detail_url, :id, :name, :profiles, :site_detail_url
  ],
  cv_fields_teams: [
    :aliases, :api_detail_url, :character_enemies, :character_friends,
    :characters, :count_of_issue_appearances, :count_of_team_members,
    :date_added, :date_last_updated, :deck, :description,
    :first_appeared_in_issue, :id,
    :image, :movies, :name, :publisher, :site_detail_url
  ],
  cv_collections: [
    "characters", "concepts", "episodes", "issues", "locations", "movies",
    "objects", "origins", "people", "powers", "publishers", "series",
    "story_arcs", "teams", "volumes"
  ],

  marvel_api_characters: MarvelApi.Characters,
  marvel_api_comics: MarvelApi.Comics,
  marvel_api_creators: MarvelApi.Creators,
  marvel_api_events: MarvelApi.Events,
  marvel_api_series: MarvelApi.Series,
  marvel_api_stories: MarvelApi.Stories,
  marvel_order_by_characters: "modified,name",
  marvel_order_by_comics: "onsaleDate,title",
  marvel_order_by_creators: "modified,lastName,firstName,middleName",
  marvel_order_by_events: "modified,name",
  marvel_order_by_series: "startYear,title",
  marvel_order_by_stories: "modified,id",
  marvel_rel_characters: ["stories", "series", "events", "comics"],
  marvel_rel_comics: ["stories", "events", "creators", "characters"],
  marvel_rel_creators: ["stories", "series", "events", "comics"],
  marvel_rel_events: ["stories", "series", "creators", "comics", "characters"],
  marvel_rel_series: ["stories", "events", "creators", "comics", "characters"],
  marvel_rel_stories: ["series", "events", "creators", "comics", "characters"],
  marvel_collections: [
    "characters", "comics", "creators", "events", "series", "stories"
  ]

import_config "#{Mix.env}.exs"

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure for your application as:
#
#     config :comics_scraper, key: :value
#
# And access this configuration in your application as:
#
#     Application.get_env(:comics_scraper, :key)
#
# Or configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
