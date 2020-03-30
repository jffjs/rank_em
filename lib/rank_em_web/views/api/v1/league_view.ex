defmodule RankEmWeb.API.V1.LeagueView do
  use RankEmWeb, :view

  def render("index.json", %{data: leagues}) do
    %{data: leagues}
  end

  def render("indexes.json", %{data: indexes}) do
    %{data: indexes}
  end
end
