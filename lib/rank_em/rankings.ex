defmodule RankEm.Rankings do
  alias RankEm.Repo
  alias RankEm.Rankings.Snapshot

  def create_snapshot(attrs \\ %{}) do
    %Snapshot{}
    |> Snapshot.changeset(attrs)
    |> Repo.insert()
  end

  def list_snapshots() do
    Repo.all(Snapshot)
  end

  def get_snapshot(id) do
    Repo.get(Snapshot, id)
  end
end
