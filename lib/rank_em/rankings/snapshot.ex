defmodule RankEm.Rankings.Snapshot do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rankings_snapshots" do
    field :index, :string
    field :conference, :string
    field :league, :string
    field :rank, :integer
    field :wins, :integer
    field :losses, :integer
    field :snapshot_ts, :naive_datetime
    field :stats, :map
    field :team, :string
    belongs_to :job, RankEm.Scrapers.Job

    timestamps()
  end

  @doc false
  def changeset(snapshot, attrs) do
    snapshot
    |> cast(attrs, [
      :index,
      :rank,
      :wins,
      :losses,
      :team,
      :conference,
      :stats,
      :snapshot_ts,
      :league,
      :job_id
    ])
    |> validate_required([
      :index,
      :rank,
      :wins,
      :losses,
      :team,
      :conference,
      :stats,
      :snapshot_ts,
      :league,
      :job_id
    ])
  end
end
