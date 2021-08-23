defmodule EtlChallenge.NumberSort do
    def sort(list) when is_list(list), do: do_sort(bubble_sort(list, []), list)

    def do_sort(sorted_list, raw_list) when sorted_list == raw_list, do: sorted_list
    def do_sort(sorted_list, raw_list) when sorted_list != raw_list do
        bubble_sort(sorted_list, []) |> do_sort(sorted_list)
    end

    def bubble_sort([], _acc), do: []
    def bubble_sort([first|[]], acc) do
        acc ++ [first]
    end
    def bubble_sort([first|[second|tail]], acc) do
        [checked_first, checked_second] = if first <= second do
            [first, second]
        else
            [second, first]
        end
        bubble_sort([checked_second|tail], acc ++ [checked_first])
    end
end
