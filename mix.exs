defmodule MoneyInputPlayground.MixProject do
  use Mix.Project

  def project do
    [
      app: :money_input_playground,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {MoneyInputPlayground.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_money_input, "~> 0.1", path: "../money_input"},
      # The visualizer's /input page renders the real HEEx
      # components — that path needs phoenix_html + LiveView at
      # runtime even though we never run a LiveSocket.
      {:phoenix_html, "~> 4.0"},
      {:phoenix_live_view, "~> 1.0"},
      {:plug, "~> 1.15"},
      {:bandit, "~> 1.5"}
    ]
  end
end
