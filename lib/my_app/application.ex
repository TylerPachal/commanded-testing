defmodule MyApp.Create do
  defstruct [:name]
end

defmodule MyApp.Created do
  @derive Jason.Encoder
  defstruct [:name]
end

defmodule MyApp.Aggregate do
  defstruct []

  def execute(%__MODULE__{}, %MyApp.Create{} = command) do
    {:ok, %MyApp.Created{name: command.name}}
  end

  def apply(state, _event) do
    state
  end
end

defmodule MyApp.Router do
  use Commanded.Commands.Router

  identify(MyApp.Aggregate, by: :name)
  dispatch([MyApp.Create], to: MyApp.Aggregate)
end

defmodule MyApp.EventHandler do
  use Commanded.Event.Handler,
    application: MyApp.CommandedApplication,
    name: "ExampleHandler"

  @impl Commanded.Event.Handler
  def handle(%type{}, _metadata) do
    IO.puts("Handle Event: #{type}")
    :ok
  end
end

defmodule MyApp.EventStore do
  use EventStore,
    otp_app: :my_app,
    serializer: Commanded.Serialization.JsonSerializer,
    username: "postgres",
    password: "postgres",
    database: "my_app_eventstore",
    hostname: "localhost",
    port: 5433
end

defmodule MyApp.CommandedApplication do
  use Commanded.Application,
    otp_app: :my_app,
    event_store: [
      # Uncomment this for in-memory adapter
      # adapter: Commanded.EventStore.Adapters.InMemory,
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: MyApp.EventStore
    ],
    pubsub: :local,
    registry: :local

  router(MyApp.Router)
end

defmodule MyApp.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyApp.CommandedApplication,
      MyApp.EventHandler
    ]

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
