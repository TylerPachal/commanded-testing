defmodule MyApp do
  def run do
    :ok = MyApp.CommandedApplication.dispatch(%MyApp.Create{name: "Tyler"})
  end
end
