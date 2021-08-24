defmodule EtlChallengeWeb.OrchestratorTest do
  use ExUnit.Case

  alias EtlChallenge.Orchestrator

  doctest Orchestrator

  setup do
    Orchestrator.purge()
  end

  test "numbers get added to the current server state" do
    Orchestrator.add_numbers(unordered_numbers())
    assert Orchestrator.get_numbers() == unordered_numbers()
    assert :ets.lookup(Orchestrator.get_table_name(), :status) == [status: :processing]
    assert :ets.lookup(Orchestrator.get_table_name(), :sorted) == [sorted: false]
  end

  test "fetch expected numbers from state" do
    for n <- 1..4 do
      Orchestrator.add_numbers(n)
    end

    assert Orchestrator.get_numbers() == [4, 3, 2, 1]
  end

  test "sort current state's numbers" do
    Orchestrator.add_numbers(unordered_numbers())
    Orchestrator.sort_numbers()

    assert Orchestrator.get_numbers() == ordered_numbers()
    assert :ets.lookup(Orchestrator.get_table_name(), :status) == [status: :completed]
    assert :ets.lookup(Orchestrator.get_table_name(), :sorted) == [sorted: true]
  end

  test "purge state" do
    Orchestrator.add_numbers(unordered_numbers())
    Orchestrator.purge()

    assert Orchestrator.get_numbers() == []
    assert :ets.lookup(Orchestrator.get_table_name(), :status) == [status: :purged]
    assert :ets.lookup(Orchestrator.get_table_name(), :sorted) == [sorted: false]
  end

  defp ordered_numbers, do: [1, 2, 3, 4, 5, 6, 7, 8, 9]
  defp unordered_numbers, do: [9, 1, 8, 2, 7, 3, 6, 4, 5]
end
