defmodule EtlChallengeWeb.ApiController do
  use EtlChallengeWeb, :controller

  alias EtlChallenge.Orchestrator

  def get_numbers(), do: Orchestrator.get_numbers()
  def get_process_info(), do: Orchestrator.get_process_info()
  def index(conn, _params) do
    %{status: process_status} = get_process_info()
    numbers = if process_status == :completed do
      get_numbers()
    else
      []
    end

    render(
      conn,
      "index.json",
      %{response: %{process_info: get_process_info(), numbers: numbers}})
  end
end
