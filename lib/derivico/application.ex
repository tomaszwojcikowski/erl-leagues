defmodule Derivico.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    :ok = Derivico.load
    # List all child processes to be supervised
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Derivico.Api,
        options: [port: 8000]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Derivico.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
