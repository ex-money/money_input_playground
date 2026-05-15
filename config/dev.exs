import Config

# Locally we still need the visualizer flag and (optionally) the
# runtime locale download. Both are off by default to keep the
# host app honest about opting in.
config :ex_money_input, visualizer: true
config :localize, allow_runtime_locale_download: true
