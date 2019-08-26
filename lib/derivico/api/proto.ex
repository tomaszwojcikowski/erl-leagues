defmodule Derivico.Api.Msg do
  use Protobuf, from: Path.expand("../proto/messages.proto", __DIR__)
end

defmodule Derivico.Api.Proto do
  require Logger
  use Plug.Router
  use Elixometer
  plug(Plug.Logger)
  # responsible for matching routes
  plug(:match)
  # responsible for dispatching responses
  plug(:dispatch)

  # A simple route to test that the server is up
  # Note, all routes must return a connection as per the Plug spec.
  get "/ping" do
    send_resp(conn, 200, "pong!")
  end

  # Handle incoming events, if the payload is the right shape, process the
  # events, otherwise return an error.
  post "/data" do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    resp =
      case body do
        "" ->
          Derivico.get_data() |> Derivico.Api.Proto.Encoder.data_to_proto()

        bin ->
          r = Derivico.Api.Msg.Request.decode(bin)

          msg =
            Derivico.get_data(r."Div", r."Season") |> Derivico.Api.Proto.Encoder.data_to_proto()

          %{msg | request: r}
      end

    resp = resp |> Derivico.Api.Proto.Encoder.add_timestamp()


    conn
    |> put_resp_content_type("application/x-protobuf")
    |> send_resp(200, Derivico.Api.Proto.Encoder.encode(resp))
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "Not found")
  end
end

# {"", "Div", "Season", "Date", "HomeTeam", "AwayTeam", "FTHG", "FTAG", "FTR", "HTHG", "HTAG", "HTR"}
defmodule Derivico.Api.Proto.Encoder do
  @spec entry_to_proto(map) :: Derivico.Api.Msg.Data.Entry.t()
  def entry_to_proto(entry) do
    %Derivico.Api.Msg.Data.Entry{
      id: entry[""],
      Div: entry["Div"],
      Season: entry["Season"],
      Date: entry["Date"],
      HomeTeam: entry["HomeTeam"],
      AwayTeam: entry["AwayTeam"],
      FTHG: entry["FTHG"],
      FTAG: entry["FTAG"],
      FTR: entry["FTR"],
      HTHG: entry["HTHG"],
      HTAG: entry["HTAG"],
      HTR: entry["HTR"]
    }
  end

  @spec data_to_proto(maybe_improper_list) :: Derivico.Api.Msg.Data.t()
  def data_to_proto(data) when is_list(data) do
    %Derivico.Api.Msg.Data{entries: Enum.map(data, &entry_to_proto/1)}
  end

  def add_timestamp(pdata) do
    %{pdata | timestamp: DateTime.utc_now() |> DateTime.to_iso8601()}
  end

  def encode(msg) do
    Derivico.Api.Msg.Data.encode(msg)
  end
end
