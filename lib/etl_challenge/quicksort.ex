defmodule EtlChallenge.Quicksort do
  def start([]), do: []
  def start(list) do
    list
    |> List.pop_at(random_element_index(list))
    |> do_quicksort()
  end

  defp do_quicksort({nil, _}), do: []
  defp do_quicksort({pivot, []}), do: [pivot]
  defp do_quicksort({pivot, sublist}) do
    require Logger
    Logger.info("#{inspect pivot}")
    smaller_elements = for x <- sublist, x < pivot, do: x
    larget_elements = for x <- sublist, x >= pivot, do: x
    do_quicksort(List.pop_at(smaller_elements, random_element_index(smaller_elements)))
    ++ [pivot] ++
    do_quicksort(List.pop_at(larget_elements, random_element_index(larget_elements)))
  end

  defp random_element_index(list) when length(list) < 3, do: 0
  defp random_element_index(list = [_|_]) do
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
end
