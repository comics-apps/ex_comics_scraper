defmodule ComicsScraper.Job do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "jobs" do
    field :type, :string
    field :priority, :integer
    field :settings, :map

    timestamps()
  end

  @fields ~w(type priority settings)

  def changeset(data, params \\ %{}) do
    data
    |> cast(params, @fields)
    |> validate_required([:type, :priority, :settings])
    |> validate_number(:priority, greater_than: 0)
  end
end
