defmodule RankEmWeb.API.V1.RankingsController do
  use RankEmWeb, :controller

  alias RankEm.Rankings

  action_fallback RankEmWeb.API.V1.FallbackController

  def index(conn, %{"league" => league, "index" => index}) do
    case Rankings.list_index_rankings(league, index) do
      [] -> :not_found
      snapshots -> render(conn, "index.json", data: snapshots)
    end
  end
end
