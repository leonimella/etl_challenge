defmodule EtlChallenge.Quicksort do
  @moduledoc """
  Documentation for `EtlChallenge.Quicksort`.
  """
  require Logger

  @ets_table_name :quicksort

  def start(list) do
    Logger.info("Initializing sort number process")
    :ets.insert(@ets_table_name, {:iteration, 0})

    list
    |> List.pop_at(random_element_index(list))
    |> do_quicksort()
  end

  defp do_quicksort({nil, _}), do: []
  defp do_quicksort({pivot, []}), do: [pivot]
  defp do_quicksort({pivot, sublist}) do
    Logger.info("pivot -> #{inspect pivot}")
    smaller_elements = for x <- sublist, x < pivot, do: x
    larget_elements = for x <- sublist, x >= pivot, do: x
    :ets.insert(@ets_table_name, {:iteration, get_interation() + 1})

    do_quicksort(List.pop_at(smaller_elements, random_element_index(smaller_elements)))
    ++ [pivot] ++
    do_quicksort(List.pop_at(larget_elements, random_element_index(larget_elements)))
  end

  defp random_element_index(list) when length(list) < 3, do: 0
  defp random_element_index([_|_] = list) do
    median =
      list
      |> Enum.take_random(3)
      |> case do
        [a, b, c] when (a >= b and a <= c) or (a <= b and a >= c) -> a
        [a, b, c] when (b >= a and b <= c) or (b <= a and b >= c) -> b
        [_, _, c] -> c
      end
    Enum.find_index(list, fn(x) -> x == median end)
  end

  # Helper Functions
  def get_table_name(), do: @ets_table_name
  def get_interation() do
    :ets.lookup(@ets_table_name, :iteration)[:iteration]
  end
  def reset_privot_interation(), do: :ets.insert(@ets_table_name, {:iteration, 0})
end
