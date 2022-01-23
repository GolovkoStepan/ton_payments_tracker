import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :ton_payments_tracker, TonPaymentsTracker.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "ton_payments_tracker_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :ton_payments_tracker, TonPaymentsTrackerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "heUola0J/LIMfNbQD7uLTdrDr8BcMiJTx6z2272Swj7kkemQeKxpNDbQqGBNoh8Z",
  server: false

# In test we don't send emails.
config :ton_payments_tracker, TonPaymentsTracker.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

config :ton_payments_tracker, TonPaymentsTracker.ApiFetcher, api_request_delay: 2_000

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
