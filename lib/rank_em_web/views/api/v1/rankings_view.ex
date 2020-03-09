defmodule RankEmWeb.API.V1.RankingsView do
  use RankEmWeb, :view

  @attributes ~w(team rank stats)a

  def render("index.json", %{data: snapshots}) do
    %{data: snapshots |> Enum.map(&Map.take(&1, @attributes))}
  end
end
