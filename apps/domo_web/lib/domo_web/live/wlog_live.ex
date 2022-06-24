defmodule DomoWeb.WlogLive do

  use DomoWeb, :live_view
  alias Domo.{Accounts, Users}
  import DomoWeb.WlogComponent

  # ----- lifecycle callbacks
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    periods = Users.get_user_periods(user.id) |> IO.inspect(label: "TONG")

    {
      :ok,
      assign(
        socket,
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
    periods = Users.get_user_periods(cuid)

    {:noreply, assign(socket, :periods, periods)}
  end

end
