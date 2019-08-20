defmodule DerivicoTest do
  use ExUnit.Case
  doctest Derivico

  test "get headers" do
    assert Derivico.get_headers() == {"", "Div", "Season", "Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "FTR", "HTHG", "HTAG", "HTR"}
  end

  test "get_data" do
    data = Derivico.get_data
    assert length(data) == 2370
    sp1 = Derivico.get_data "SP1", "201617"
    assert length(sp1) == 380
    assert Derivico.get_data "error", "err" == []
  end
end
