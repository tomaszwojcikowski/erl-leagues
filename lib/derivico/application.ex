defmodule Derivico.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    Logger.info("Starting Application...")
    path = System.get_env("DATA_FILE", "priv/Data.csv")
    json_port = System.get_env("JSON_PORT", "8000") |> String.to_integer
    proto_port = System.get_env("PROTO_PORT", "8001") |> String.to_integer
    :ok = Derivico.load_data(path)

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Derivico.Api.JSON,
        options: [port: json_port]
      ),
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Derivico.Api.Proto,
        options: [port: proto_port]
      )
    ]

    opts = [strategy: :one_for_one, name: Derivico.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
