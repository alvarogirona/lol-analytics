defmodule LoLAnalytics.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LoLAnalytics.Repo,
      {DNSCluster, query: Application.get_env(:lol_analytics, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: LoLAnalytics.PubSub},
      {Task.Supervisor, name: LoLAnalytics.TaskSupervisor}
      # Start a worker by calling: LoLAnalytics.Worker.start_link(arg)
      # {LoLAnalytics.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: LoLAnalytics.Supervisor)
  end
end
