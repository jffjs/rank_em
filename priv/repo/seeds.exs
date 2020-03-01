# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RankEm.Repo.insert!(%RankEm.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias RankEm.Users

{:ok, _user} =
  Users.create(%{
    email: "admin@rankm.app",
    password: "ChangeMe123",
    password_confirmation: "ChangeMe123"
  })
