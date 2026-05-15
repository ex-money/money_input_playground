defmodule MoneyInputPlayground.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/ex-money/money_input_playground"

  def project do
    [
      app: :money_input_playground,
      version: @version,
      name: "MoneyInputPlayground",
      source_url: @source_url,
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      docs: docs(),
      dialyzer: [
        plt_add_apps: ~w(ecto gettext mix phoenix_html phoenix_live_view plug bandit)a,
        flags: [
          :error_handling,
          :unknown,
          :underspecs,
          :extra_return,
          :missing_return
        ]
      ]
    ]
  end

  def application do
    [
      mod: {MoneyInputPlayground.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp description do
    "Deployable host for `MoneyInputPlayground.Visualizer` — Bandit + a host " <>
      "router (favicon, robots.txt, /healthz) that forwards to the visualizer. " <>
      "Used to deploy https://elixir-money-input.fly.dev. Not published to hex."
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      main: "readme",
      extras: [
        "README.md",
        "CHANGELOG.md",
        "LICENSE.md"
      ],
      formatters: ["html"],
      groups_for_modules: groups_for_modules(),
      skip_code_autolink_to: [
        "Plug.Conn.t/0",
        "Supervisor.child_spec/0"
      ],
      skip_undefined_reference_warnings_on: ["CHANGELOG.md"]
    ]
  end

  defp groups_for_modules do
    [
      Host: [
        MoneyInputPlayground.Application,
        MoneyInputPlayground.Router
      ],
      Visualizer: ~r/^MoneyInputPlayground\.Visualizer(\.|$)/,
      Gettext: [MoneyInputPlayground.Gettext],
      Exceptions: [MoneyInputPlayground.VisualizerDisabledError]
    ]
  end

  defp deps do
    [
      {:ex_money_input, "~> 0.2"},
      {:localize_web, "~> 0.7"},
      # The visualizer's /input page renders the real HEEx
      # components — that path needs phoenix_html + LiveView at
      # runtime even though we never run a LiveSocket.
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_view, "~> 1.0"},
      {:gettext, "~> 1.0"},
      {:plug, "~> 1.15"},
      {:bandit, "~> 1.5"},
      {:ex_doc, "~> 0.30", only: [:dev, :release], runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false}
    ]
  end
end
