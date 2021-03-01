defmodule RankEmWeb.Admin.JobController do
  use RankEmWeb, :controller

  alias RankEm.Scheduling
  alias RankEm.Scheduling.Job

  def index(conn, _params) do
    jobs = Scheduling.list_jobs(50)
    render(conn, "index.html", jobs: jobs)
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: Scheduling.change_job(%Job{}))
  end

  def create(conn, %{"job" => %{"scraper" => scraper}}) do
    case Scheduling.create_ad_hoc_job(String.to_existing_atom(scraper)) do
      {:ok, job} ->
        conn
        |> put_flash(:info, "Ad-hoc Job created successfully.")
        |> redirect(to: Routes.job_path(conn, :show, job))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    render(conn, "show.html", job: Scheduling.get_job(id))
  end

  def start(conn, %{"id" => id}) do
    job = Scheduling.get_job!(id)

    with {:ok, job} <- Scheduling.start_job(job) do
      Scheduling.execute_job_async(job)

      conn
      |> put_flash(:info, "Job started.")
      |> redirect(to: Routes.job_path(conn, :show, job))
    end
  end

  def stop(conn, %{"id" => id}) do
    job = Scheduling.get_job!(id)
    Scheduling.stop_job(job)

    conn
    |> put_flash(:info, "Job stopped.")
    |> redirect(to: Routes.job_path(conn, :show, job))
  end
end
