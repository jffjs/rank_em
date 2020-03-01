defmodule RankEm.Users do
  use Pow.Ecto.Context, repo: RankEm.Repo, user: RankEm.Users.User
end
