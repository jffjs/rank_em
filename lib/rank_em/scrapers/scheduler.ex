defmodule RankEm.Scrapers.Scheduler do
  use GenServer

  alias RankEm.Scrapers

  @interval_msec 60 * 1000

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, nil, opts)
  end

  def add_schedule(scheduler \\ __MODULE__, schedule) do
    GenServer.cast(scheduler, {:add_schedule, schedule})
  end

  def init(_) do
    IO.puts("Scheduler: starting...")
    Process.send_after(self(), :check_schedules, @interval_msec)
    {:ok, Scrapers.list_schedules()}
  end

  def handle_cast({:add_schedule, schedule}, schedules) do
    {:noreply, [schedule | schedules]}
  end

  def handle_info(:check_schedules, schedules) do
    IO.puts("Scheduler: checking schedules...")

    for schedule <- schedules do
      if Scrapers.should_schedule_job?(schedule) do
        IO.puts("Scheduler: starting job for schedule id #{schedule.id}")
        {:ok, job} = Scrapers.create_scheduled_job(schedule)
        Task.Supervisor.async(Scrapers.JobSupervisor, Scrapers, :start_job, [job])
      end
    end

    Process.send_after(self(), :check_schedules, @interval_msec)
    {:noreply, schedules}
  end

  def handle_info({ref, {:ok, %Scrapers.Job{} = job}}, schedules) do
    Process.demonitor(ref, [:flush])

    IO.puts("Scheduler: job id #{job.id} - status #{job.status}")
    {:noreply, schedules}
  end
end
