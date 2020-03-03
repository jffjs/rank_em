defmodule RankEm.Scrapers do
  alias RankEm.Scrapers

  # TODO:
  # NCAAB: AP, Coaches, Massey, Sagarin, TeamRankings
  @scrapers Enum.map(
              [
                Scrapers.NCAAB.Kenpom,
                Scrapers.NCAAB.Torvik,
                Scrapers.NCAAB.Net,
                Scrapers.NCAAB.ApPoll
              ],
              &Atom.to_string/1
            )

  def list_scrapers() do
    @scrapers
  end
end
