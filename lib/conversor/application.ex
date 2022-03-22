defmodule Conversor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Conversor.Repo,
      # Start the Telemetry supervisor
      ConversorWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Conversor.PubSub},
      # Start the Endpoint (http/https)
      ConversorWeb.Endpoint,
      # Start a worker by calling: Conversor.Worker.start_link(arg)
      # {Conversor.Worker, arg}
      # Starts DB_SERVER
      {Conversor.Database.DBServer, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Conversor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ConversorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
