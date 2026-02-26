# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
mix deps.get          # install dependencies
mix compile           # compile
mix test              # run all tests
mix test test/my_app_test.exs:5  # run a single test by line number
iex -S mix            # start IEx with the app running
```

To manually exercise the command dispatch:

```elixir
MyApp.run()
```

## Architecture

This is a test harness for the local Commanded library at `/Users/tyler/dev.noindex/personal/commanded`. The `commanded` dep points to that local path with `override: true`.

The entire CQRS stack lives in `lib/my_app/application.ex`:

- **Command** (`MyApp.Create`) → dispatched via `MyApp.CommandedApplication.dispatch/1`
- **Router** (`MyApp.Router`) → identifies aggregates by `:name`, routes `Create` to `MyApp.Aggregate`
- **Aggregate** (`MyApp.Aggregate`) → `execute/2` returns events; `apply/2` updates state
- **Event** (`MyApp.Created`) → derives `Jason.Encoder` for JSON serialization
- **Event Handler** (`MyApp.EventHandler`) → handles all events; currently just prints the event type
- **Application** (`MyApp.CommandedApplication`) → uses in-memory event store with JSON serializer, local pubsub and registry

The supervision tree (started by `MyApp.Application`) starts `MyApp.CommandedApplication` then `MyApp.EventHandler` as children.
