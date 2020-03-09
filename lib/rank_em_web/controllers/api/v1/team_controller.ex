defmodule RankEmWeb.API.V1.TeamController do
  use RankEmWeb, :controller

  alias RankEm.Rankings

  action_fallback RankEmWeb.API.V1.FallbackController

  def index(conn, %{"league" => league}) do
    render(conn, "index.json", data: Rankings.list_teams(league))
  end

  @spec team(any, map) :: :not_found | Plug.Conn.t()
  def team(conn, %{"league" => league, "team" => team}) do
    case Rankings.list_team_rankings(league, team) do
      [] -> :not_found
      snapshots -> render(conn, "team.json", data: snapshots)
    end
  end

  def ranking(conn, %{"league" => league, "team" => team, "index" => index}) do
    case Rankings.team_ranking_for_index(league, team, index) do
      nil -> :not_found
      snapshot -> render(conn, "ranking.json", data: snapshot)
    end
  end
end
