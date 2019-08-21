defmodule Derivico.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    :ok = Derivico.load()
    children = [
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: Derivico.Api.JSON,
        options: [port: 8000]
      )
    ]

    opts = [strategy: :one_for_one, name: Derivico.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
