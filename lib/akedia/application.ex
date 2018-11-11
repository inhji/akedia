defmodule Akedia.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Akedia.Repo,
      # Start the endpoint when the application starts
      AkediaWeb.Endpoint
      # Starts a worker by calling: Akedia.Worker.start_link(arg)
      # {Akedia.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Akedia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    AkediaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
