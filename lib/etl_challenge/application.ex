defmodule EtlChallenge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @request_initial_page 1

  def start(_type, _args) do
    # Start Client request loop
    Task.async(fn -> EtlChallenge.Client.init_request_loop(@request_initial_page) end)

    children = [
      # Start the Telemetry supervisor
      EtlChallengeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: EtlChallenge.PubSub},
      # Start the Endpoint (http/https)
      EtlChallengeWeb.Endpoint,
      # Start a worker by calling: EtlChallenge.Worker.start_link(arg)
      # {EtlChallenge.Worker, arg}
      {EtlChallenge.Orchestrator, []}
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
