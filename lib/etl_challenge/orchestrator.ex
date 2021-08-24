defmodule EtlChallenge.Orchestrator do
  @moduledoc """
  Documentation for `EtlChallenge.Orchestrator`.
  """

  @ets_table_name :etl_challenge

  use GenServer

  alias EtlChallenge.Quicksort

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    :ets.new(@ets_table_name, [:set, :public, :named_table])
    :ets.new(Quicksort.get_table_name(), [:set, :public, :named_table])
    {:ok, []}
  end

  def handle_call(:purge, _from, _state) do
    :ets.insert(@ets_table_name, {:status, :purged})
    :ets.insert(@ets_table_name, {:sorted, false})
    :ets.insert(@ets_table_name, {:size, 0})
    Quicksort.reset_privot_iteration()

    {:reply, :ok, []}
  end

  def handle_call(:get_numbers, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:sort_numbers, _}, state) do
    :ets.insert(@ets_table_name, {:status, :sorting})
    new_state = Quicksort.start(state)
    :ets.insert(@ets_table_name, {:status, :completed})
    :ets.insert(@ets_table_name, {:sorted, true})
    {:noreply, new_state}
  end

  def handle_cast({:add_numbers, number_list}, state) do
    :ets.insert(@ets_table_name, {:status, :processing})
    :ets.insert(@ets_table_name, {:sorted, false})
    case :ets.lookup(@ets_table_name, :size) do
      [] ->
        :ets.insert(@ets_table_name, {:size, length(number_list)})
      [size: size] ->
        :ets.insert(@ets_table_name, {:size, size + length(number_list)})
    end

    {:noreply, state ++ number_list}
  end

  # Helper functions
  def add_numbers(number_list), do: GenServer.cast(__MODULE__, {:add_numbers, number_list})
  def sort_numbers(), do: GenServer.cast(__MODULE__, {:sort_numbers, nil})
  def get_numbers(), do: GenServer.call(__MODULE__, :get_numbers, :infinity)
  def purge(), do: GenServer.call(__MODULE__, :purge)

  # ETS Helper functions
  def get_table_name(), do: @ets_table_name
  def get_process_info() do
    %{
      size: :ets.lookup(@ets_table_name, :size)[:size],
      status: :ets.lookup(@ets_table_name, :status)[:status],
      sort_process: %{
        status: :ets.lookup(@ets_table_name, :sorted)[:sorted],
        pivot_iterations: Quicksort.get_iteration()
      }
    }
  end
end
