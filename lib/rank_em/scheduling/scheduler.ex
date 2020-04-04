defmodule RankEm.Scheduling.Scheduler do
  require Logger
  use GenServer

  alias RankEm.Scheduling
  alias RankEm.Scheduling.Job

  @interval_msec 60 * 1000

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def update_schedules() do
    GenServer.cast(__MODULE__, :update_schedules)
  end

  def init(_) do
    if IEx.started?() || System.get_env("DISABLE_SCHEDULER") do
      :ignore
    else
      log("Starting...")
      Process.send_after(self(), :check_schedules, @interval_msec)
      {:ok, Scheduling.list_schedules()}
    end
  end

  def handle_cast(:update_schedules, _schedules) do
    log("Updating schedules...")
    {:noreply, Scheduling.list_schedules()}
  end

  def handle_info(:check_schedules, schedules) do
    Logger.debug("Checking schedules...")

    for schedule <- schedules do
      {:ok, schedule} =
        cond do
          Scheduling.should_schedule_activate?(schedule) ->
            Scheduling.update_schedule(schedule, %{status: "active"})

          Scheduling.should_schedule_deactivate?(schedule) ->
            Scheduling.update_schedule(schedule, %{status: "inactive"})

          true ->
            {:ok, schedule}
        end

      if Scheduling.should_schedule_job?(schedule) do
        log("Starting job for schedule id #{schedule.id}")
        {:ok, job} = Scheduling.create_scheduled_job(schedule)
        Scheduling.start_and_run_job_async(job)
      end
    end

    Process.send_after(self(), :check_schedules, @interval_msec)
    {:noreply, schedules}
  end

  def handle_info({ref, {:ok, %Job{} = job}}, schedules) do
    Process.demonitor(ref, [:flush])

    log("Job id #{job.id} - status #{job.status}")
    {:noreply, schedules}
  end

  defp log(msg) do
    Logger.info("Scheduler: #{msg}")
  end
end
