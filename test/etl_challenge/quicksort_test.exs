defmodule EtlChallengeWeb.QuicksortTest do
  use ExUnit.Case
  doctest EtlChallenge.Quicksort

  test "quick sorting algorithm test" do
    unordered_list = [9, 1, 8, 2, 7, 3, 6, 4, 5]
    expected = [1, 2, 3, 4, 5, 6, 7, 8, 9]

    assert EtlChallenge.Quicksort.start(unordered_list) == expected
  end
end
