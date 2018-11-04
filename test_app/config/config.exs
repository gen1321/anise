# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :absinthe_test_app, AbsintheTestAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "x3gVc53QxbJ6bbv57Gh/Zk2gzLnjkb3H8g9plU8eJ+kxbo1d1aMRCAo+r3yot82J",
  render_errors: [view: AbsintheTestAppWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: AbsintheTestApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
