defmodule RankEm.Rankings do
  import Ecto.Query, only: [from: 2, except: 2]

  alias RankEm.Repo
  alias RankEm.Rankings
  alias RankEm.Rankings.{League, Snapshot}

  @leagues ~w(ncaab)

  def create_leagues(attrs) do
    %League{} |> League.changeset(attrs) |> Repo.insert()
  end

  def list_leagues() do
    @leagues
  end

  def list_teams(league) do
    query =
      from s in Snapshot,
        select: s.team,
        where: s.league == ^league,
        distinct: s.team,
        order_by: [asc: :team]

    Repo.all(query)
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

  def list_index_rankings(league, index) do
    query =
      from s in Snapshot,
        where: s.index == ^index and s.league == ^league,
        distinct: [asc: s.rank],
        order_by: [desc: :snapshot_ts]

    Repo.all(query)
  end

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

  def list_index_teams_diff(league, index1, index2) do
    q1 = distinct_teams_query(league, index1)
    q2 = distinct_teams_query(league, index2) |> except(^q1)
    Repo.all(q2)
  end

  def list_index_conferences_diff(league, index1, index2) do
    q1 = distinct_conferences_query(league, index1)
    q2 = distinct_conferences_query(league, index2) |> except(^q1)
    Repo.all(q2)
  end

  defp distinct_teams_query(league, index) do
    from s in Snapshot,
      select: s.team,
      where: s.league == ^league and s.index == ^index,
      distinct: s.team
  end

  defp distinct_conferences_query(league, index) do
    from s in Snapshot,
      select: s.conference,
      where: s.league == ^league and s.index == ^index,
      distinct: s.conference
  end
end
