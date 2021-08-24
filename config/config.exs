# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :etl_challenge, EtlChallengeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eyJVO2CvXNiq2o0w3ULFDTtk6R6PzDQtI0bBnpz+SKuZqNZqeZiD2dD1Ub8xT7cZ",
  render_errors: [view: EtlChallengeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EtlChallenge.PubSub,
  live_view: [signing_salt: "WLMQb5za"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Tesla Adapter
config :tesla, adapter: Tesla.Adapter.Hackney

# ETL Challenge
config :etl_challenge,
  base_url: "http://challenge.dienekes.com.br",
  intial_page: 1

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
