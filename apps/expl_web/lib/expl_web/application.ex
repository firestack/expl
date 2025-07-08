defmodule ExplWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExplWeb.Telemetry,
      # Start a worker by calling: ExplWeb.Worker.start_link(arg)
      # {ExplWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      ExplWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ExplWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ExplWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
