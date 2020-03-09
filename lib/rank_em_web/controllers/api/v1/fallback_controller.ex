defmodule RankEmWeb.API.V1.FallbackController do
  use RankEmWeb, :controller

  def call(conn, :not_found) do
    conn
    |> put_status(:not_found)
    |> put_view(RankEmWeb.ErrorView)
    |> render("404.json")
  end
end
