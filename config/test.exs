import Config

# Don't start the web server during tests.
config :money_input_playground, start_server: false

# Visualizer needs to be enabled for the routes to mount.
config :money_input_playground, visualizer: true

# Test locales beyond the pre-compiled set.
config :localize, allow_runtime_locale_download: true
