defmodule RankEm.Scrapers.NCAAB.Normalize do
  @conference_map %{
    "big10" => "B10",
    "bigten" => "B10",
    "big12" => "B12",
    "bigtwelve" => "B12",
    "mountainwest" => "MWC",
    "pac-12" => "P12",
    "pac12" => "P12",
    "pactwelve" => "P12",
    "bigeast" => "BE",
    "aac" => "Amer",
    "socon" => "SC",
    "atlantic10" => "A10",
    "atlanticten" => "A10",
    "atlanticsun" => "ASun",
    "asun" => "ASun",
    "ivy league" => "Ivy",
    "ivy" => "Ivy",
    "southland" => "Slnd",
    "c-usa" => "CUSA",
    "bigwest" => "BW",
    "bigsky" => "BSky",
    "sunbelt" => "SB",
    "patriot" => "Pat",
    "pat" => "Pat",
    "horizon" => "Horz",
    "summit" => "Sum",
    "summitleague" => "Sum",
    "bigsouth" => "BSth",
    "americaeast" => "AE"
  }
  def conference(conf) do
    normalized = conf |> String.replace(~r/\s/, "") |> String.downcase()
    Map.get(@conference_map, normalized, conf)
  end

  @team_map %{
    "ETSU" => "Eastern Tennessee St.",
    "Saint Mary's (CA)" => "Saint Mary's",
    "SFA" => "Stephen F. Austin",
    "Northern Colo." => "Northern Colorado",
    "Saint Francis (PA)" => "St. Francis PA",
    "Prairie View" => "Prairie View A&M",
    "LMU (CA)" => "Loyola Marymount",
    "N.C. Central" => "North Carolina Central",
    "Mississippi Val." => "Mississippi Valley St.",
    "Central Conn. St." => "Central Conneticut",
    "Southeastern La." => "Southeastern Louisiana",
    "North Carolina St." => "N.C. State",
    "Fort Wayne" => "Purdue Fort Wayne",
    "LIU Brooklyn" => "LIU",
    "College of Charleston" => "Charleston",
    "Louisiana Lafayette" => "Louisiana"
  }

  def team(team) do
    Map.get(@team_map, team, team)
  end
end
