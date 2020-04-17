defmodule RankEmWeb.Router do
  use RankEmWeb, :router
  use Pow.Phoenix.Router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin" do
    pipe_through :browser

    pow_session_routes()
  end

  scope "/admin", RankEmWeb.Admin do
    pipe_through [:browser, :protected]

    live_dashboard "/sys_dashboard", metrics: RankEmWeb.Telemetry

    resources "/schedules", ScheduleController
    resources "/jobs", JobController, only: [:index, :new, :create, :show]
    post "/jobs/:id/start", JobController, :start

    get "/reports", ReportsController, :index
    get "/reports/failed_jobs", ReportsController, :failed_jobs
  end

  scope "/", RankEmWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", RankEmWeb.API.V1, as: :api_v1 do
    pipe_through :api

    get "/leagues", LeagueController, :index
    get "/leagues/:league/indexes", LeagueController, :indexes

    get "/rankings/:league/:index", RankingsController, :index

    get "/teams/:league", TeamController, :index
    get "/teams/:league/:team", TeamController, :team
    get "/teams/:league/:team/:index", TeamController, :ranking
  end
end
