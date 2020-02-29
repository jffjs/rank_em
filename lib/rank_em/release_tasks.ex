defmodule RankEm.ReleaseTasks do
  @moduledoc false

  @start_apps [
    :crypto,
    :ssl,
    :postgrex,
    :ecto,
    :ecto_sql
  ]

  @apps [
    :rank_em
  ]

  @repos [
    RankEm.Repo
  ]

  def migrate() do
    startup()

    # Run migrations
    Enum.each(@apps, &run_migrations_for/1)

    # Signal shutdown
    IO.puts("Success!")
  end

  defp startup() do
    IO.puts("Loading rank_em...")

    # Load the code for rank_em, but don't start it
    Application.load(:rank_em)

    IO.puts("Starting dependencies..")
    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)

    # Start the Repo(s) for rank_em
    IO.puts("Starting repos..")
    Enum.each(@repos, & &1.start_link(pool_size: 2))
  end

  def priv_dir(app), do: "#{:code.priv_dir(app)}"

  defp run_migrations_for(app) do
    IO.puts("Running migrations for #{app}")
    Ecto.Migrator.run(RankEm.Repo, migrations_path(app), :up, all: true)
  end

  defp migrations_path(app), do: Path.join([priv_dir(app), "repo", "migrations"])
end
