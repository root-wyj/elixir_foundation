# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :websocket_web,
  namespace: WebsocketWeb

# Configures the endpoint
config :websocket_web, WebsocketWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KncLf/roGjFricsocJjPs2hxtDKduHPds6nCv9OAEwTlFqNxtQcTAaREth0487/M",
  render_errors: [view: WebsocketWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: WebsocketWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :websocket_web, :generators,
  context_app: :websocket

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
