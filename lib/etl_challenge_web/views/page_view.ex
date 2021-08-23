defmodule EtlChallengeWeb.PageView do
  use EtlChallengeWeb, :view
  alias EtlChallenge.Orchestrator

  def get_numbers(), do: Orchestrator.get_numbers()
end
