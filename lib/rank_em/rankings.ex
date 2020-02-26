defmodule RankEm.Rankings do
  alias RankEm.Repo
  alias RankEm.Rankings.Snapshot

  def create_snapshot(attrs \\ %{}) do
    %Snapshot{}
    |> Snapshot.changeset(attrs)
    |> Repo.insert()
  end
end
