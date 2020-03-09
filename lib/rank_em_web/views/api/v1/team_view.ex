defmodule RankEmWeb.API.V1.TeamView do
  use RankEmWeb, :view

  @attributes ~w(index rank stats)a

  def render("index.json", %{data: teams}) do
    %{data: teams}
  end

  def render("team.json", %{data: snapshots}) do
    %{data: snapshots |> Enum.map(&Map.take(&1, @attributes))}
  end

  def render("ranking.json", %{data: snapshot}) do
    %{data: Map.take(snapshot, @attributes)}
  end
end
