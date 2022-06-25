defmodule DomoWeb.WlogLive do

  use DomoWeb, :live_view
  alias Domo.{Accounts, Users, Counter}
  import DomoWeb.WlogComponent

  # ----- lifecycle callbacks
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    uid = user.id |> Integer.to_string()
    periods = Users.get_user_periods(user.id)

    Phoenix.PubSub.subscribe(Domo.PubSub, uid)

    {
      :ok,
      assign(
        socket,
        s_count: 0,
        page_title: "Domo",
        session_id: session["live_socket_id"],
        periods: periods,
        current_user: user
      )
    }
  end

  # ----- event callbacks

  def handle_event("start-period", %{"secs" => dsecs} = _data, socket) do
    secs = dsecs |> String.to_integer()
    cuid = socket.assigns[:current_user].id

    Users.start_user_period(cuid, secs)
    Counter.start(cuid, secs)

    periods = Users.get_user_periods(cuid)

    {:noreply, assign(socket, :periods, periods)}
  end

  def handle_info({"tick", secs}, socket) do
    {:noreply, assign(socket, s_count: secs, page_title: title(secs) )}
  end

  # ----- view helpers

  def title(secs) when secs < 0 do
    str = secs |> Util.Seconds.to_s()
    "Domo <#{str}>"
  end

  def title(secs) do
    str = secs |> Util.Seconds.to_s()
    "Domo #{str}"
  end

end
