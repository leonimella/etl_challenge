defmodule EtlChallenge.Processor do
  @moduledoc """
  Documentation for `EtlChallenge.Processor`.
  """
  use GenServer

  alias EtlChallenge.Quicksort

  def start_link(state \\ %{sorted?: false, numbers: []}) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    {:ok, %{sorted?: false, numbers: []}}
  end

  def handle_call(:purge, _from, _state) do
    {:reply, :ok, %{sorted?: false, numbers: []}}
  end

  def handle_call(:get_numbers, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:sort_numbers, _}, state) do
    {:noreply, %{sorted?: true, numbers: Quicksort.start(state.numbers)}}
  end

  def handle_cast({:add_numbers, number_list}, state) do
    {:noreply, %{sorted?: false, numbers: state.numbers ++ number_list}}
  end

  def add_numbers(number_list), do: GenServer.cast(__MODULE__, {:add_numbers, number_list})
  def sort_numbers(), do: GenServer.cast(__MODULE__, {:sort_numbers, nil})
  def get_numbers(), do: GenServer.call(__MODULE__, :get_numbers, :infinity)
  def purge(), do: GenServer.call(__MODULE__, :purge)
end
