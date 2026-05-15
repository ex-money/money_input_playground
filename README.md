# MoneyInputPlayground

A standalone deployment wrapper for [`Money.Input.Visualizer`](../money_input) — the locale-aware number and money input demo that ships with the [`money_input`](../money_input) library.

The live instance runs at **<https://elixir-money-input.fly.dev>**.

## What it is

The `money_input` library includes a Plug-based visualizer (`Money.Input.Visualizer`) for previewing the `<.number_input>`, `<.money_input>`, and `<.currency_picker>` components across locales and currencies. The visualizer is a library component — there's no Application module, no supervision tree, no release config in the upstream package. Users run it from `iex` during development.

`money_input_playground` is a tiny wrapper that turns the visualizer into a deployable web app:

- **`MoneyInputPlayground.Application`** — supervises a Bandit listener.
- **`MoneyInputPlayground.Router`** — adds host-level routes (favicon, robots.txt, `/healthz`) and forwards everything else to `Money.Input.Visualizer`.
- **`config/runtime.exs`** — reads `PORT` and `IP` from the environment and flips on the visualizer's safety gate.
- **`Dockerfile`** + **`fly.toml`** — production deployment to Fly.io.

The `money_input` library itself is unchanged — `money_input_playground` depends on it as a regular dep.

## Local development

```bash
mix deps.get
mix run --no-halt
# Visit http://localhost:8080
```

By default the server binds to `0.0.0.0:8080`. Override either with environment variables:

```bash
PORT=4001 IP=loopback mix run --no-halt
# Now bound to 127.0.0.1:4001
```

`IP` accepts `"any"` (default → `0.0.0.0`) or `"loopback"` (`127.0.0.1`).

## Tests

```bash
mix test
```

The test suite uses `Plug.Test` to exercise every route without binding a real socket. `config/test.exs` sets `start_server: false` so `mix test` doesn't conflict with anything else listening on port 8080.

## Production deployment (Fly.io)

```bash
fly deploy
```

The Dockerfile is a standard multi-stage Elixir release build:

1. **Builder stage** — `hexpm/elixir:1.19.5-erlang-28.2-debian-bookworm-20260202-slim`. Runs `mix deps.get --only prod`, `mix compile`, `mix release`.
2. **Runtime stage** — `debian:bookworm-slim` with `libstdc++6`, `openssl`, `libncurses5`, `locales`, `ca-certificates`. Copies the release. `CMD ["/app/bin/money_input_playground", "start"]`.

No Node.js, no asset pipeline, no static-file directory. The visualizer's CSS, JS, and component assets are compiled into the BEAM at build time inside the `money_input` library.

`fly.toml` defaults:

- App: `elixir-money-input`
- Region: `iad` (Virginia)
- VM: `shared-cpu-1x`, 256 MB
- HTTP service on internal port 8080, force HTTPS
- HTTP health check at `/healthz` every 15 seconds
- `auto_stop_machines = "stop"` and `min_machines_running = 0` — the app suspends when idle and wakes on the next request

## Updating the visualizer

The visualizer's UI lives in the `money_input` library. To pick up changes locally, both projects share a `path:` dep in `mix.exs`:

```elixir
{:ex_money_input, "~> 0.1", path: "../money_input"}
```

Before publishing the playground app, switch to a hex version constraint so `fly deploy` doesn't try to bundle a sibling directory:

```elixir
{:ex_money_input, "~> 0.1"}
```

## Routes

Provided by `MoneyInputPlayground.Router`:

| Path | Source |
|---|---|
| `/favicon.ico` | 1×1 transparent GIF (the library ships no logo) |
| `/robots.txt` | hardcoded `User-agent: * / Disallow: /` |
| `/healthz` | plain `ok` for Fly.io health checks |
| everything else | forwarded to `Money.Input.Visualizer` (`/input`, `/parse`, `/format`, `/locale`, `/assets/...`) |

See the [visualizer module docs](../money_input/lib/money/input/visualizer.ex) and [the integration guide](../money_input/guides/integration.md) for details on each tab.

## License

Apache 2.0 — same as the upstream `money_input` library.
