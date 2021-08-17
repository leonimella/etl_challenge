defmodule EtlChallengeWeb.PageController do
  use EtlChallengeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
