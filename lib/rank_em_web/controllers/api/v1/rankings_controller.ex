defmodule RankEmWeb.API.V1.RankingsController do
  use RankEmWeb, :controller

  action_fallback RankEmWeb.API.V1.FallbackController
end
