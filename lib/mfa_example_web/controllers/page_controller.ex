defmodule MfaExampleWeb.PageController do
  use MfaExampleWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
