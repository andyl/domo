defmodule DomoWeb.PageController do
  use DomoWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def count(conn, _params) do
    conn
    |> put_layout(false)
    |> put_root_layout(false)
    |> render("count.html")
  end
end
