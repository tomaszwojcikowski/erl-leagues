defmodule Derivico.Api do
  use Plug.Router
  plug(Plug.Logger)
  # responsible for matching routes
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
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
          {200, Derivico.get_data(div, season)}

        _ ->
          {200, Derivico.get_data()}
      end

    send_resp(conn, status, body |> Poison.encode!())
  end

  # A catchall route, 'match' will match no matter the request method,
  # so a response is always returned, even if there is no route to match.
  match _ do
    send_resp(conn, 404, "oops... Nothing here :(")
  end
end
