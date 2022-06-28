defmodule DomoWeb.BaseController do
  use DomoWeb, :controller

  def secs(conn, _params) do

    text(conn, Termato.Counter.get_secs())
  end

  def mins(conn, _params) do
    text(conn, Termato.Counter.get_secs() / 60)
  end

  def secs_to_s(conn, _params) do
    text(conn, Termato.Counter.get_secs() |> Util.Seconds.to_s())
  end

  def decrement(conn, _params) do
    Termato.Counter.decrement()
    text(conn, Termato.Counter.get_secs())
  end

  def set_secs(conn, params) do
    params["secs"] |> Termato.Counter.set_secs()
    text(conn, "ok")
  end

  def set_mins(conn, params) do
    params["mins"] |> Termato.Counter.set_mins()
    text(conn, "ok")
  end
end
