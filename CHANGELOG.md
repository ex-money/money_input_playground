# Changelog

## [v0.1.0] — 2026-05-15

* `MoneyInputPlayground.Visualizer` and related view modules — Plug-based visualizer that demos every `ex_money_input` component across CLDR locales and currencies. Moved from `ex_money_input` 0.1; renamed from `Money.Input.Visualizer.*` to `MoneyInputPlayground.Visualizer.*`.

* `MoneyInputPlayground.Application` + `MoneyInputPlayground.Router` — Bandit listener and host-level routes (favicon, robots.txt, `/healthz`) that forward everything else to the visualizer. Dockerfile + `fly.toml` deploy to Fly.io; live instance at <https://elixir-money-input.fly.dev>.

* `MoneyInputPlayground.Gettext` — Localize-interpolated Gettext backend hosting the visualizer's UI catalog. Ships with de, fr, and ja translations covering headings, descriptions, table headers, form labels, hints, and empty-state text.
