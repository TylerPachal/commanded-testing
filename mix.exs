defmodule MyApp.MixProject do
  use Mix.Project

  def project do
    [
      app: :my_app,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {MyApp.Application, []}
    ]
  end

  def aliases do
    [
      reset: ["event_store.drop", "event_store.create", "event_store.init"]
    ]
  end

  defp deps do
    [
      {:commanded, path: "/Users/tyler/dev.noindex/personal/commanded", override: true},
      {:commanded_eventstore_adapter, "~> 1.4"},
      {:eventstore, path: "/Users/tyler/dev.noindex/personal/eventstore", override: true},
      {:jason, "~> 1.4"}
    ]
  end
end
