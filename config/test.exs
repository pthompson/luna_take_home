import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :luna_take_home, LunaTakeHomeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "gilE33IXxIskS+QNQ1X8KxQOk42n5KLWPnUpKhVPYxlNrZ4hgBrH8XLbQqNMOcz0",
  server: false

# In test we don't send emails.
config :luna_take_home, LunaTakeHome.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Prevent Oban from running jobs and plugins during test runs
config :luna_take_home, Oban, testing: :inline
