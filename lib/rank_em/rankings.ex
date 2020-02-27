defmodule RankEm.Rankings do
  alias RankEm.Repo
  alias RankEm.Rankings
  alias RankEm.Rankings.Snapshot

  @leagues ~w(ncaab)

  def list_leagues() do
    @leagues
  end

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

  def list_team_rankings("ncaab", team), do: Rankings.NCAAB.list_team_rankings(team)
  def list_team_rankings(_invalid_league, _team), do: []
end
