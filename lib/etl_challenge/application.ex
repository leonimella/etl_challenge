defmodule EtlChallenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      EtlChallenge.Repo,
      # Start the Telemetry supervisor
      EtlChallengeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EtlChallenge.PubSub},
      # Start the Endpoint (http/https)
      EtlChallengeWeb.Endpoint
      # Start a worker by calling: EtlChallenge.Worker.start_link(arg)
      # {EtlChallenge.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EtlChallenge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EtlChallengeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
