defmodule RankEm.Rankings do
  import Ecto.Query, only: [from: 2]

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

  def team_ranking_for_index(league, team, index) do
    query =
      from s in Snapshot,
        where: s.team == ^team and s.index == ^index and s.league == ^league,
        order_by: [desc: :snapshot_ts],
        limit: 1

    Repo.all(query) |> List.first()
  end

  def list_team_rankings("ncaab", team), do: Rankings.NCAAB.list_team_rankings(team)
  def list_team_rankings(_invalid_league, _team), do: []

  def team_conferences(teams, league) when is_list(teams) do
    query =
      from s in Snapshot,
        select: {s.team, s.conference},
        where: s.team in ^teams and s.league == ^league,
        distinct: s.team

    Repo.all(query)
  end

  def team_conferences(team, league) when is_binary(team) do
    query =
      from s in Snapshot,
        select: {s.team, s.conference},
        where: s.team == ^team and s.league == ^league,
        distinct: s.team

    Repo.all(query)
  end
end
