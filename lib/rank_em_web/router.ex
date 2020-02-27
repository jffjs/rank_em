defmodule RankEmWeb.Router do
  use RankEmWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RankEmWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api/v1", RankEmWeb.API.V1, as: :api_v1 do
    pipe_through :api

    get "/teams/:league/:team", TeamController, :team
  end
end
