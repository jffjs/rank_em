defmodule RankEm.Scrapers.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  alias RankEm.Scrapers
  alias RankEm.Scrapers.Job

  @statuses ~w(active inactive)
  @min_interval 60

  schema "scraper_schedules" do
    field :interval_seconds, :integer
    field :scraper, :string
    field :status, :string
    has_many :jobs, Job

    timestamps()
  end

  @doc false
  def changeset(schedule, attrs) do
    schedule
    |> cast(attrs, [:scraper, :interval_seconds, :status])
    |> validate_required([:scraper, :interval_seconds, :status])
    |> validate_inclusion(:status, statuses())
    |> validate_inclusion(:scraper, Scrapers.list_scrapers())
    |> validate_number(:interval_seconds, greater_than_or_equal_to: @min_interval)
  end

  def statuses() do
    @statuses
  end
end
