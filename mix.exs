defmodule Derivico.MixProject do
  use Mix.Project

  def project do
    [
      app: :derivico,
      version: "1.0.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [
        plt_add_deps: :transitive
      ],
      releases: [
        prod: [
          applications: [runtime_tools: :permanent]
        ]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :exprotobuf, :beaker],
      mod: {Derivico.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:csv, "~> 2.3"},
      {:plug_cowboy, "~> 2.1"},
      {:poison, "~> 4.0"},
      {:exprotobuf, "~> 1.2"},
      {:beaker, ">= 1.2.0"},
      {:logger_file_backend, "~> 0.0.11"},
      {:dialyxir, "~> 0.5", only: [:dev], runtime: false}
    ]
  end
end
