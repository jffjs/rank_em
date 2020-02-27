defmodule RankEmWeb.API.V1.TeamController do
  use RankEmWeb, :controller

  alias RankEm.Rankings

  def team(conn, %{"league" => league, "team" => team}) do
    case Rankings.list_team_rankings(league, team) do
      [] -> :not_found
      snapshots -> render(conn, "team.json", data: snapshots)
    end
  end
end
