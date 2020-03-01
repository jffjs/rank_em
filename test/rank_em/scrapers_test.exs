defmodule RankEm.ScrapersTest do
  use RankEm.DataCase

  alias RankEm.Scrapers

  describe "schedules" do
    alias RankEm.Scrapers.Schedule

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def schedule_fixture(attrs \\ %{}) do
      {:ok, schedule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Scrapers.create_schedule()

      schedule
    end

    test "list_schedules/0 returns all schedules" do
      schedule = schedule_fixture()
      assert Scrapers.list_schedules() == [schedule]
    end

    test "get_schedule!/1 returns the schedule with given id" do
      schedule = schedule_fixture()
      assert Scrapers.get_schedule!(schedule.id) == schedule
    end

    test "create_schedule/1 with valid data creates a schedule" do
      assert {:ok, %Schedule{} = schedule} = Scrapers.create_schedule(@valid_attrs)
    end

    test "create_schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Scrapers.create_schedule(@invalid_attrs)
    end

    test "update_schedule/2 with valid data updates the schedule" do
      schedule = schedule_fixture()
      assert {:ok, %Schedule{} = schedule} = Scrapers.update_schedule(schedule, @update_attrs)
    end

    test "update_schedule/2 with invalid data returns error changeset" do
      schedule = schedule_fixture()
      assert {:error, %Ecto.Changeset{}} = Scrapers.update_schedule(schedule, @invalid_attrs)
      assert schedule == Scrapers.get_schedule!(schedule.id)
    end

    test "delete_schedule/1 deletes the schedule" do
      schedule = schedule_fixture()
      assert {:ok, %Schedule{}} = Scrapers.delete_schedule(schedule)
      assert_raise Ecto.NoResultsError, fn -> Scrapers.get_schedule!(schedule.id) end
    end

    test "change_schedule/1 returns a schedule changeset" do
      schedule = schedule_fixture()
      assert %Ecto.Changeset{} = Scrapers.change_schedule(schedule)
    end
  end
end
