defmodule RankEm.Scrapers do
  alias RankEm.Scrapers

  # TODO:
  # NCAAB: Massey, Sagarin, TeamRankings
  @scrapers Enum.map(
              [
                Scrapers.NCAAB.Kenpom,
                Scrapers.NCAAB.Torvik,
                Scrapers.NCAAB.Net,
                Scrapers.NCAAB.ApPoll,
                Scrapers.NCAAB.CoachesPoll,
                Scrapers.NCAAB.Massey
              ],
              &Atom.to_string/1
            )

  def list_scrapers() do
    @scrapers
  end
end
