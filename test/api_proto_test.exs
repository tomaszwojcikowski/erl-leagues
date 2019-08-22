defmodule Derivico.ApiProtoTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Derivico.Api.Proto.init([])

  test "it returns pong" do
    # Create a test connection
    conn = conn(:get, "/ping")

    # Invoke the plug
    conn = Derivico.Api.Proto.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "pong!"
  end

  test "all data" do
    conn = conn(:post, "/data")
    conn = Derivico.Api.Proto.call(conn, @opts)
    assert conn.status == 200
    r = Derivico.Api.Msg.Data.decode(conn.resp_body)
    assert length(r.entries) == 2370
  end

  test "some data" do
    conn = conn(:post, "/data", %{"div" => "SP2", "season" => "201617"})
    conn = Derivico.Api.Proto.call(conn, @opts)
    assert conn.status == 200
    r = Derivico.Api.Msg.Data.decode(conn.resp_body)
    assert length(r.entries) == 462

    expect = %Derivico.Api.Msg.Data.Entry{
      FTAG: "1",
      Season: "201617",
      AwayTeam: "Getafe",
      Date: "12/05/2017",
      Div: "SP2",
      FTHG: "2",
      FTR: "H",
      HTAG: "0",
      HTHG: "1",
      HTR: "H",
      HomeTeam: "Sevilla B",
      id: "1168"
    }

    assert List.first(r.entries) == expect
  end

  test "Not found" do
    conn = conn(:get, "/other")
    conn = Derivico.Api.Proto.call(conn, @opts)
    assert conn.status == 404
  end
end
