# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :rank_em,
  ecto_repos: [RankEm.Repo]

# Configures the endpoint
config :rank_em, RankEmWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6N3SFuqnsIYSg5LICAAhG9mWPOodXZyhVfF3n+Qx9x8im/JXtUfTyl8Tg/ynV9LB",
  render_errors: [view: RankEmWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: RankEm.PubSub,
  live_view: [signing_salt: "Ob6xX7eZDrZi3KiqqJo+IlW8KUHfB6Ag"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :rank_em, :pow,
  user: RankEm.Users.User,
  users_context: RankEm.Users,
  repo: RankEm.Repo,
  web_module: RankEmWeb

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
