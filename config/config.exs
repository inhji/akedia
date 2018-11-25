# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :akedia,
  ecto_repos: [Akedia.Repo]

# Configures the endpoint
config :akedia, AkediaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "XMM4KKV5tVGkyNFW3KEt9bxiwuXKOUWQs5P7cuTg3OBK/b+fE5aIRACs4fxlbyAf",
  render_errors: [view: AkediaWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Akedia.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :arc,
  storage: Arc.Storage.Local

config :scrivener_html,
  routes_helper: Akedia.Router.Helpers,
  view_style: :bulma

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
