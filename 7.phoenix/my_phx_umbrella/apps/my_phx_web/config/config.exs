# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :my_phx_web,
  namespace: MyPhxWeb

# Configures the endpoint
config :my_phx_web, MyPhxWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9WrSM9ECC+VQbyiJd2Bl0MlkS4drdIvTRE8ORA7tV4nlZXvJyhShZZUrRpeRqNLV",
  render_errors: [view: MyPhxWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: MyPhxWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :my_phx_web, :generators,
  context_app: :my_phx

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
