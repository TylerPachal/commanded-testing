defmodule MyApp do
  def dispatch do
    :ok = MyApp.CommandedApplication.dispatch(%MyApp.Command.Create{name: "Tyler"})
  end

  def dispatch_many(amount \\ 10) do
    for _ <- 1..amount do
      :ok = MyApp.CommandedApplication.dispatch(%MyApp.Command.Create{name: "Tyler"})
    end
  end
end
