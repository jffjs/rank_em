defmodule RankEmWeb.Admin.ReportsController do
  use RankEmWeb, :controller

  alias RankEm.Reports

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def failed_jobs(conn, _params) do
    to = NaiveDateTime.utc_now()
    from = NaiveDateTime.add(to, -24 * 3600)
    jobs = Reports.list_failed_jobs(from, to)
    render(conn, "failed_jobs.html", jobs: jobs)
  end

  def hung_jobs(conn, _params) do
    jobs = Reports.list_hung_jobs()
    render(conn, "hung_jobs.html", jobs: jobs)
  end
end
