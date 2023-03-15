defmodule DomoWeb.PageController do
  use DomoWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
