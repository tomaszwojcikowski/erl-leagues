defmodule Derivico.ProtoTest do
  use ExUnit.Case, async: true

  test "encoder" do
    entry = %{
      "" => "257",
      "AwayTeam" => "La Coruna",
      "Date" => "05/03/2017",
      "Div" => "SP1",
      "FTAG" => "1",
      "FTHG" => "0",
      "FTR" => "A",
      "HTAG" => "1",
      "HTHG" => "0",
      "HTR" => "A",
      "HomeTeam" => "Sp Gijon",
      "Season" => "201617"
    }

    p_entry = %Derivico.Api.Msg.Data.Entry{
      id: "257",
      Div: "SP1",
      Season: "201617",
      Date: "05/03/2017",
      HomeTeam: "Sp Gijon",
      AwayTeam: "La Coruna",
      FTHG: "0",
      FTAG: "1",
      FTR: "A",
      HTHG: "0",
      HTAG: "1",
      HTR: "A"
    }

    proto = Derivico.Api.Proto.Encoder.data_to_proto([entry])
    assert %Derivico.Api.Msg.Data{entries: [p_entry]} == proto
  end
end
