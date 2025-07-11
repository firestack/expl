# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :expl, Expl.Feeds,
  feed_key_map: %{
    bus: ["mbta_bus_", "trip_updates"],
    subway_vehicle: ["rtr", "VehiclePositions"],
    subway: ["rtr", "TripUpdates"],
    cr: ["mbta_cr_", "trip_updates"],
    cr_vehicle: ["mbta_cr_", "vehicle_positions"],
    cr_boarding: ["com_TripUpdates_enhanced"],
    winthrop: ["mbta_winthrop_", "trip_updates"],
    concentrate: [
      "concentrate_TripUpdates_enhanced",
      "realtime_TripUpdates_enhanced"
    ],
    concentrate_vehicle: [
      "concentrate_VehiclePositions_enhanced",
      "realtime_VehiclePositions_enhanced"
    ],
    alerts: ["Alerts_enhanced"],
    busloc: ["busloc", "TripUpdates"],
    busloc_vehicle: ["busloc", "VehiclePositions"],
    swiftly_bus_vehicle: ["goswift.ly", "mbta_bus", "vehicle_positions"]
  }

# Configure Mix tasks and generators
config :expl,
  ecto_repos: [Expl.Repo]

config :expl_web,
  ecto_repos: [Expl.Repo],
  generators: [context_app: :expl]

# Configures the endpoint
config :expl_web, ExplWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: ExplWeb.ErrorHTML, json: ExplWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Expl.PubSub,
  live_view: [signing_salt: "+ZNlv9VQ"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  expl_web: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../apps/expl_web/assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  expl_web: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../apps/expl_web/assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
