defmodule DomoWeb.PageController do
  use DomoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
