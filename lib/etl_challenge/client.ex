defmodule EtlChallenge.Client do
  use Tesla

  require Logger

  plug Tesla.Middleware.BaseUrl, "http://challenge.dienekes.com.br"
  plug Tesla.Middleware.JSON

  def init_request_loop(page) do
    request_loop(page, true)
  end

  defp request_loop(_page, _continue? = false) do
    Logger.info("Reached final page")
  end

  defp request_loop(page, _continue? = true) do
    continue? = request_next_page?(get_numbers(Integer.to_string(page)))
    request_loop(page + 1, continue?)
  end

  defp request_next_page?([_|_]), do: true
  defp request_next_page?([]), do: false

  defp get_numbers(page) do
    Logger.info("Requesting page #{inspect page}")
    case get("/api/numbers?page=" <> page) do
      {:ok, %{body: %{"numbers" => numbers}}} ->
        # Push to GenServer
        numbers
      {:ok, %{body: %{"error" => _error}}} ->
        Logger.warn("API call error at page #{inspect page}, trying again")
        get_numbers(page)
      _ ->
        Logger.error("Unknow error. Stopping request_loop")
        []
    end
  end
end
