defmodule MultibullsWeb.PageController do
  use MultibullsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
