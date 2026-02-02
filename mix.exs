defmodule MyApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_app,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {MyApp.Application, []}
    ]
  end

  defp deps do
    [
      {:commanded, path: "/Users/tyler/dev.noindex/personal/commanded", override: true},
      {:commanded_eventstore_adapter, "~> 1.4"},
      {:jason, "~> 1.4"}
    ]
  end
end
