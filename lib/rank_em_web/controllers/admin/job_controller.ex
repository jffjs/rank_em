defmodule RankEmWeb.Admin.JobController do
  use RankEmWeb, :controller

  alias RankEm.Scheduling
  alias RankEm.Scheduling.Job

  def new(conn, _params) do
    render(conn, "new.html", changeset: Scheduling.change_job(%Job{}))
  end
end
