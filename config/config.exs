# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger,
  backends: [:console],
  compile_time_purge_level: :debug

config :logger, :console, level: :info

config :exometer_core, report: [reporters: [{:exometer_report_tty, []}]]

config :elixometer,
  reporter: :exometer_report_tty,
  env: Mix.env(),
  metric_prefix: "derivico"
