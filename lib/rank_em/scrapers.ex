defmodule RankEm.Scrapers do
  import Ecto.Query, only: [from: 2]
  alias RankEm.Repo
  alias RankEm.Scrapers
  alias RankEm.Scrapers.{Job, Scraper, Schedule}
  alias RankEm.Rankings

  @scrapers Enum.map(
              [
                Scrapers.NCAAB.Kenpom,
                Scrapers.NCAAB.Torvik,
                Scrapers.NCAAB.Net
              ],
              &Atom.to_string/1
            )

  def list_scrapers() do
    @scrapers
  end

  def create_schedule(attrs \\ %{}) do
    %Schedule{}
    |> Schedule.changeset(attrs)
    |> Repo.insert()
  end

  def get_schedule(id), do: Repo.get(Schedule, id)

  def get_schedule!(id), do: Repo.get!(Schedule, id)

  def list_schedules do
    Repo.all(Schedule)
  end

  def update_schedule(%Schedule{} = schedule, attrs) do
    schedule |> Schedule.changeset(attrs) |> Repo.update()
  end

  def delete_schedule(%Schedule{} = schedule) do
    Repo.delete(schedule)
  end

  def change_schedule(%Schedule{} = schedule) do
    Schedule.changeset(schedule, %{})
  end

  def should_schedule_job?(_schedule) do
  end

  def create_scheduled_job(%Schedule{scraper: scraper} = schedule) do
    %Job{}
    |> Job.changeset(%{status: "pending", scraper: scraper})
    |> Job.put_schedule(schedule)
    |> Repo.insert()
  end

  def create_ad_hoc_job(scraper) do
    %Job{}
    |> Job.changeset(%{status: "pending", scraper: Atom.to_string(scraper)})
    |> Repo.insert()
  end

  def get_last_run_job(%Schedule{id: schedule_id}) do
    query =
      from(j in Job,
        where: j.schedule_id == ^schedule_id and j.status == "done",
        order_by: [desc: :start_ts],
        limit: 1
      )

    case Repo.all(query) do
      [job] -> job
      _ -> nil
    end
  end

  @spec update_job(Job.t(), map()) :: {:ok, Job.t()} | {:error, Ecto.Changeset.t()}
  def update_job(job, attrs \\ %{}) do
    job
    |> Job.changeset(attrs)
    |> Repo.update()
  end

  def list_jobs() do
    Repo.all(Job)
  end

  def get_job(id) do
    Repo.get(Job, id)
  end

  def start_job(%Job{status: "pending"} = job) do
    start_ts = NaiveDateTime.utc_now()

    with {:ok, job} <- update_job(job, %{start_ts: start_ts, status: "running"}) do
      run_job(job)
    end
  end

  def run_job(%Job{status: "running"} = job) do
    scraper = String.to_existing_atom(job.scraper)

    with {:ok, results} <- Scraper.scrape(scraper) do
      for attrs <- results do
        attrs
        |> Map.put(:job_id, job.id)
        |> Map.put(:snapshot_ts, job.start_ts)
        |> Rankings.create_snapshot()
      end

      job_successful(job)
    else
      {:error, reason} ->
        job_failed(job, reason)
    end
  end

  defp job_successful(%Job{status: "running"} = job) do
    end_ts = NaiveDateTime.utc_now()
    update_job(job, %{end_ts: end_ts, status: "done"})
  end

  defp job_failed(%Job{status: "running"} = job, failure_msg) do
    end_ts = NaiveDateTime.utc_now()
    update_job(job, %{end_ts: end_ts, status: "failed", failure_msg: failure_msg})
  end
end
