defmodule EtlChallengeWeb.PageView do
  use EtlChallengeWeb, :view
  alias EtlChallenge.Orchestrator

  def get_numbers(), do: Orchestrator.get_numbers()
  def get_process_info(), do: Orchestrator.get_process_info()
end
