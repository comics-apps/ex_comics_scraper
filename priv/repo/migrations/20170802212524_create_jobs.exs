defmodule ComicsScraper.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :type, :string
      add :priority, :integer
      add :settings, :map

      timestamps()
    end

    create index(:jobs, [:type, :priority])
  end
end
