defmodule RankEmWeb.Admin.ScheduleController do
  use RankEmWeb, :controller

  alias RankEm.Scrapers
  alias RankEm.Scrapers.Schedule

  def index(conn, _params) do
    schedules = Scrapers.list_schedules()
    render(conn, "index.html", schedules: schedules)
  end

  def new(conn, _params) do
    changeset = Scrapers.change_schedule(%Schedule{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"schedule" => schedule_params}) do
    case Scrapers.create_schedule(schedule_params) do
      {:ok, schedule} ->
        conn
        |> put_flash(:info, "Schedule created successfully.")
        |> redirect(to: Routes.schedule_path(conn, :show, schedule))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    schedule = Scrapers.get_schedule!(id)
    render(conn, "show.html", schedule: schedule)
  end

  def edit(conn, %{"id" => id}) do
    schedule = Scrapers.get_schedule!(id)
    changeset = Scrapers.change_schedule(schedule)
    render(conn, "edit.html", schedule: schedule, changeset: changeset)
  end

  def update(conn, %{"id" => id, "schedule" => schedule_params}) do
    schedule = Scrapers.get_schedule!(id)

    case Scrapers.update_schedule(schedule, schedule_params) do
      {:ok, schedule} ->
        conn
        |> put_flash(:info, "Schedule updated successfully.")
        |> redirect(to: Routes.schedule_path(conn, :show, schedule))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", schedule: schedule, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    schedule = Scrapers.get_schedule!(id)
    {:ok, _schedule} = Scrapers.delete_schedule(schedule)

    conn
    |> put_flash(:info, "Schedule deleted successfully.")
    |> redirect(to: Routes.schedule_path(conn, :index))
  end
end
