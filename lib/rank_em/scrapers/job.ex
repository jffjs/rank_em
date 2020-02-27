defmodule RankEm.Scrapers.Job do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ~w(pending running done failed)
  @scrapers ~w(Elixir.RankEm.Scrapers.NCAAB.Kenpom Elixir.RankEm.Scrapers.NCAAB.Torvik)

  schema "scraper_jobs" do
    field :end_ts, :naive_datetime
    field :scraper, :string
    field :start_ts, :naive_datetime
    field :status, :string
    field :failure_msg, :string

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:scraper, :start_ts, :end_ts, :status, :failure_msg])
    |> validate_required([:scraper, :status])
    |> validate_inclusion(:status, @statuses)
    |> validate_inclusion(:scraper, @scrapers)
  end
end
