# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger, :error_log,
  path: "log/error.log",
  level: :debug
