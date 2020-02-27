defmodule RankEm.Scrapers do
  alias RankEm.Repo
  alias RankEm.Scrapers.Job
  alias RankEm.Rankings

  def create_job(scraper) do
    %Job{}
    |> Job.changeset(%{status: "pending", scraper: Atom.to_string(scraper)})
    |> Repo.insert()
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
    results = apply(scraper, :scrape, [])

    for attrs <- results do
      attrs
      |> Map.put(:job_id, job.id)
      |> Map.put(:snapshot_ts, job.start_ts)
      |> Rankings.create_snapshot()
    end

    job_successful(job)
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
