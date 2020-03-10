defmodule RankEm.Reports do
  import Ecto.Query, only: [from: 2]

  alias RankEm.Repo
  alias RankEm.Scheduling.Job

  def list_failed_jobs(from, to) do
    query =
      from j in Job, where: j.start_ts >= ^from and j.start_ts < ^to and j.status == "failed"

    Repo.all(query)
  end
end
