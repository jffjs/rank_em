defmodule RankEm.Reports do
  import Ecto.Query, only: [from: 2]

  alias RankEm.Repo
  alias RankEm.Scheduling.Job

  def list_failed_jobs(from, to) do
    query =
      from j in Job, where: j.start_ts >= ^from and j.start_ts < ^to and j.status == "failed"

    Repo.all(query)
  end

  def list_hung_jobs(running_time_seconds \\ 3600) do
    threshold_ts = NaiveDateTime.add(NaiveDateTime.utc_now(), -running_time_seconds)
    query = from j in Job, where: j.start_ts <= ^threshold_ts and j.status == "running"

    Repo.all(query)
  end
end
