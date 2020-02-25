defmodule RankEmWeb.PageController do
  use RankEmWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
