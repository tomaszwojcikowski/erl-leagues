defmodule Derivico.Api.Msg do
  use Protobuf, """
    message Data {
      message Entry {
        required string id = 1;
        required string Div = 2;
        required string Season = 3;
        required string Date = 4;
        required string HomeTeam = 5;
        required string AwayTeam = 6;
        required string FTHG = 7;
        required string FTAG = 8;
        required string FTR = 9;
        required string HTHG = 10;
        required string HTAG = 11;
        required string HTR = 12;
      }

      repeated Entry entries = 1;
    }
  """
end

defmodule Derivico.Api.Proto do
  require Logger
  use Plug.Router
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
    {status, body} =
      case conn.body_params do
        %{"div" => div, "season" => season} ->
          data = Derivico.get_data(div, season)
          proto = Derivico.Api.Proto.Encoder.data_to_proto(data)
          {200, proto}

        _ ->
          data = Derivico.get_data()
          {200, Derivico.Api.Proto.Encoder.data_to_proto(data)}
      end

    send_resp(conn, status, Derivico.Api.Proto.Encoder.encode(body))
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

  @spec data_to_proto([map]) :: Derivico.Api.Msg.Data.t()
  def data_to_proto(data) when is_list(data) do
    %Derivico.Api.Msg.Data{entries: Enum.map(data, &entry_to_proto/1)}
  end

  def encode(msg) do
    Derivico.Api.Msg.Data.encode(msg)
  end
end
