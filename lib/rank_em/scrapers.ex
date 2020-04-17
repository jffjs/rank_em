defmodule RankEm.Scrapers do
  alias RankEm.Scrapers

  @scrapers Enum.map(
              [
                ### NCAAB ###
                Scrapers.NCAAB.Kenpom,
                Scrapers.NCAAB.Torvik,
                Scrapers.NCAAB.Net,
                Scrapers.NCAAB.ApPoll,
                Scrapers.NCAAB.CoachesPoll,
                Scrapers.NCAAB.Massey,
                Scrapers.NCAAB.Sagarin,
                ### NCAAF ###
                Scrapers.NCAAF.FPI
                # Scrapers.NCAAF.SPPLus,
                # Scrapers.NCAAF.FEI,
                # Scrapers.NCAAF.ApPoll,
                # Scrapers.NCAAF.CoachesPoll,
                # Scrapers.NCAAF.CFP,
                # Scrapers.NCAAF.Massey,
                # Scrapers.NCAAF.Sagarin,
              ],
              &Atom.to_string/1
            )

  def list_scrapers() do
    @scrapers
  end
end
