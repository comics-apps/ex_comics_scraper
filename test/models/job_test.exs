defmodule ComicsScraper.JobsTest do
  alias ComicsScraper.{Job, Repo}
  use ExUnit.Case

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  test "returns false for invalid Job" do
    job = Job.changeset(%Job{}, %{priority: 0})
    assert false == job.valid?
  end

  test "allows to save valid Job" do
    attributes = %{priority: 1, type: "test", settings: %{foo: "bar"}}
    job = Job.changeset(%Job{}, attributes) |> Repo.insert!
    assert nil != job.id
  end
end