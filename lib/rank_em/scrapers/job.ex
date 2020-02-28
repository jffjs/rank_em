defmodule RankEm.Scrapers.Job do
  use Ecto.Schema
  import Ecto.Changeset

  alias RankEm.Scrapers

  @statuses ~w(pending running done failed)

  schema "scraper_jobs" do
    field :end_ts, :naive_datetime
    field :scraper, :string
    field :start_ts, :naive_datetime
    field :status, :string
    field :failure_msg, :string
    belongs_to :schedule, Scrapers.Schedule

    timestamps()
  end

  @doc false
  def changeset(job, attrs) do
    job
    |> cast(attrs, [:scraper, :start_ts, :end_ts, :status, :failure_msg])
    |> validate_required([:scraper, :status])
    |> validate_inclusion(:status, @statuses)
    |> validate_inclusion(:scraper, Scrapers.list_scrapers())
  end

  def put_schedule(changeset, schedule) do
    put_assoc(changeset, :schedule, schedule)
  end
end
