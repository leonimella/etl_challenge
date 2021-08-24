defmodule EtlChallengeWeb.ApiView do
  use EtlChallengeWeb, :view

  def render("index.json", %{response: response}), do: response
end
