defmodule LunaTakeHome.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start Repo
      LunaTakeHome.Repo,
      # Start Oban
      {Oban, Application.fetch_env!(:luna_take_home, Oban)},
      # Start the Telemetry supervisor
      LunaTakeHomeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: LunaTakeHome.PubSub},
      # Start the Endpoint (http/https)
      LunaTakeHomeWeb.Endpoint
      # Start a worker by calling: LunaTakeHome.Worker.start_link(arg)
      # {LunaTakeHome.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LunaTakeHome.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LunaTakeHomeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
