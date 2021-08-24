defmodule EtlChallenge.Client do
  use Tesla

  require Logger

  alias EtlChallenge.Orchestrator

  @base_url Application.get_env(:etl_challenge, :base_url)
  @initial_page Application.get_env(:etl_challenge, :initial_page, 1)

  plug Tesla.Middleware.BaseUrl, @base_url
  plug Tesla.Middleware.JSON

  def init_request_loop() do
    request_loop(@initial_page, true)
  end

  defp request_loop(_page, _continue? = false) do
    Logger.info("Reached final page")
    Orchestrator.sort_numbers()
  end

  defp request_loop(page, _continue? = true) do
    continue? = request_next_page?(get_numbers(page))
    request_loop(page + 1, continue?)
  end

  defp request_next_page?([_ | _]), do: true
  defp request_next_page?([]), do: false

  defp get_numbers(page) do
    Logger.info("Requesting page #{page}")

    case get("/api/numbers?page=#{page}") do
      {:ok, %{body: %{"numbers" => numbers}}} ->
        Orchestrator.add_numbers(numbers)
        numbers

      {:ok, %{body: %{"error" => _error}}} ->
        Logger.warn("API call error on page #{page}, trying again")
        get_numbers(page)

      _ ->
        Logger.error("Unknow error. Stopping request_loop")
        []
    end
  end
end
