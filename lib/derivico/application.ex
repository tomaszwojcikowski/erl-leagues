defmodule Derivico.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    Logger.debug("Starting Application...")
    path = System.get_env("DATA_FILE", "priv/Data.csv")
    :ok = Derivico.load_data(path)

    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Derivico.Api.JSON,
        options: [port: 8000]
      ),
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Derivico.Api.Proto,
        options: [port: 8001]
      )
    ]

    opts = [strategy: :one_for_one, name: Derivico.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
