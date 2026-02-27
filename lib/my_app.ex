defmodule MyApp do
  def dispatch do
    :ok = MyApp.CommandedApplication.dispatch(%MyApp.Command.Create{name: "Tyler"})
  end

  def dispatch_many(amount \\ 10) do
    for _ <- 1..amount do
      :ok = MyApp.CommandedApplication.dispatch(%MyApp.Command.Create{name: "Tyler"})
    end
  end

  def append_many_directly_to_store(amount \\ 10) do
    event = %MyApp.Event.Created{name: "Tyler"}

    event_data = %Commanded.EventStore.EventData{
      causation_id: nil,
      correlation_id: nil,
      event_type: Commanded.EventStore.TypeProvider.to_string(event),
      data: event,
      metadata: %{}
    }

    events = Enum.map(1..amount, fn _ -> event_data end)

    Commanded.EventStore.append_to_stream(
      MyApp.CommandedApplication,
      "Tyler",
      :any_version,
      events
    )
  end
end
