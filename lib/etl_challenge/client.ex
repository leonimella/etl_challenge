defmodule EtlChallenge.Client do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "http://challenge.dienekes.com.br"
  plug Tesla.Middleware.JSON

  def get_numbers(page) do
    {:ok, %{body: %{numbers: numbers}}} = get("/api/numbers?page=" <> page)
    body
  end
end
