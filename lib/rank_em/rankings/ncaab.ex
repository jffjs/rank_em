defmodule RankEm.Rankings.NCAAB do
  import Ecto.Query, only: [from: 2]

  alias RankEm.Repo
  alias RankEm.Rankings.Snapshot

  @indexes ~w(ap_poll coaches_poll kenpom massey net sagarin torvik)

  def list_indexes() do
    @indexes
  end

  def list_team_rankings(team) do
    team |> latest_team_snapshots_by_index() |> Repo.all()
  end

  defp latest_team_snapshots_by_index(team) do
    from(s in Snapshot,
      where: s.team == ^team,
      distinct: s.index,
      order_by: [desc: :snapshot_ts]
    )
  end
end
