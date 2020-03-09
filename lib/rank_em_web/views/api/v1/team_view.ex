defmodule RankEmWeb.API.V1.TeamView do
  use RankEmWeb, :view

  @attributes ~w(index rank stats)a

  def render("team.json", %{data: snapshots}) do
    %{data: snapshots |> Enum.map(&Map.take(&1, @attributes))}
  end

  def render("index_for_team.json", %{data: snapshot}) do
    %{data: Map.take(snapshot, @attributes)}
  end
end
