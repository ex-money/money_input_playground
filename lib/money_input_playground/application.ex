defmodule MoneyInputPlayground.Application do
  @moduledoc """
  OTP Application that runs `Money.Input.Visualizer` as a
  supervised Bandit web server.

  Reads configuration from `config/runtime.exs`:

  * `PORT` environment variable (default `"8080"`).
  * `IP` environment variable: `"any"` → `{0,0,0,0}`,
    `"loopback"` → `{127,0,0,1}`. Default `"any"`.

  """

  use Application

  @impl true
  def start(_type, _args) do
    children =
      if Application.get_env(:money_input_playground, :start_server, true) do
        port = Application.get_env(:money_input_playground, :port, 8080)
        ip = Application.get_env(:money_input_playground, :ip, {0, 0, 0, 0})

        [{Bandit, plug: MoneyInputPlayground.Router, port: port, ip: ip}]
      else
        []
      end

    Supervisor.start_link(children,
      strategy: :one_for_one,
      name: MoneyInputPlayground.Supervisor
    )
  end
end
