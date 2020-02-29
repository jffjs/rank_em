import Config

config :rank_em, RankEmWeb.Endpoint,
  http: [:inet6, port: 4000],
  url: [host: "rankm.app", port: 443, scheme: "https"],
  cache_static_manifest: "priv/static/cache_manifest.json"

config :rank_em, RankEmWeb.Endpoint, secret_key_base: System.get_env("SECRET_KEY_BASE")

config :rank_em, RankEm.Repo,
  url: System.get_env("DATABASE_URL"),
  pool_size: 15

config :phoenix, :serve_endpoints, true

config :logger, level: :info
