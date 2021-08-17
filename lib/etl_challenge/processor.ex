defmodule EtlChallenge.Processor do
  @moduledoc """
  Documentation for `EtlChallenge.Processor`.
  """
  use GenServer

  alias EtlChallenge.Client

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_stack) do
    require Logger
    Logger.info("Response -> #{inspect Client.get_numbers(Integer.to_string(1))}")

    {:ok, %{}}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:push, ip_list}, state) do
    {
      :noreply,
      Enum.reduce(ip_list, state, fn ip, acc ->
        acc
        |> Map.update(ip, 1, fn ip_count -> ip_count + 1 end)
      end)
    }
  end
end
