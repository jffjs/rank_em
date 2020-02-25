defmodule RankEm.Repo do
  use Ecto.Repo,
    otp_app: :rank_em,
    adapter: Ecto.Adapters.Postgres
end
