defmodule RankEmWeb.API.V1.LeagueController do
  use RankEmWeb, :controller

  alias RankEm.Rankings

  def index(conn, _params) do
    render(conn, "index.json", data: Rankings.list_leagues())
  end

  def indexes(conn, %{"league" => league}) do
    render(conn, "indexes.json", data: Rankings.list_league_indexes(league))
  end
end
