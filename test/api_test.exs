defmodule Derivico.ApiTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Derivico.Api.JSON.init([])

  test "it returns pong" do
    # Create a test connection
    conn = conn(:get, "/ping")

    # Invoke the plug
    conn = Derivico.Api.JSON.call(conn, @opts)

    # Assert the response and status
    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "pong!"
  end

  test "all data" do
    conn = conn(:post, "/data")
    conn = Derivico.Api.JSON.call(conn, @opts)
    assert conn.status == 200
    r = conn.resp_body |> Poison.decode!()
    assert length(r) == 2370
  end

  test "some data" do
    conn = conn(:post, "/data", %{"div" => "SP1", "season" => "201617"})
    conn = Derivico.Api.JSON.call(conn, @opts)
    assert conn.status == 200
    r = conn.resp_body |> Poison.decode!()
    assert length(r) == 380

    assert List.first(r) == %{
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
  end

  test "Not found" do
    conn = conn(:get, "/other")
    conn = Derivico.Api.JSON.call(conn, @opts)
    assert conn.status == 404
  end

end
