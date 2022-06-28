defmodule DomoWeb.WlogLive do

  use DomoWeb, :live_view

  alias Domo.Counter
  alias Domo.Ctx
  import DomoWeb.WlogComponent
  import DomoWeb.LiveHelpers

  alias DomoWeb.Router.Helpers, as: Routes

  # ----- lifecycle callbacks
  def mount(_params, session, socket) do
    user = Ctx.Accounts.get_user_by_session_token(session["user_token"])
    uid = user.id |> Integer.to_string()
    periods = Ctx.Users.get_user_periods(user.id)

    Phoenix.PubSub.subscribe(Domo.PubSub, uid)

    {
      :ok,
      assign(
        socket,
        tz: get_tz(socket),
        sec_str: "",
        sec_klas: "green",
        s_count: 0,
        page_title: "Domo",
        session_id: session["live_socket_id"],
        periods: periods,
        edit_period: nil,
        current_user: user
      )
    }
  end

  def handle_params(%{"id" => sseq}, _uri, socket) do
    uid = socket.assigns[:current_user].id
    iseq = sseq |> String.to_integer()
    period = Ctx.Users.get_user_period(uid, iseq)
    case period do
      nil -> {:noreply, socket}
      result -> {:noreply, assign(socket, :edit_period, result)}
    end
  end

  def handle_params(%{}, _uri, socket) do
    {:noreply, assign(socket, :edit_period, nil)}
  end

  # ----- event callbacks

  def handle_event("start-period", %{"secs" => dsecs} = _data, socket) do
    secs = dsecs |> String.to_integer()
    cuid = socket.assigns[:current_user].id

    Ctx.Users.start_user_period(cuid, secs)
    Counter.start(cuid, secs)

    periods = Ctx.Users.get_user_periods(cuid)

    {:noreply, assign(socket, :periods, periods)}
  end

  def handle_info({"tick", secs}, socket) do
    opts = [
      s_count: secs,
      sec_str: sec_to_str(secs),
      sec_klas: secs |> Util.Seconds.klas(),
      page_title: title(secs)
    ]
    {:noreply, assign(socket, opts)}
  end

  # ----- view helpers

  def ldate(date, zone) do
    case DateTime.shift_zone(date, zone) do
      {:ok, dt} -> DateTime.truncate(dt, :second) |> Calendar.strftime("%b-%d %H:%M")
      {:error, _dt} -> DateTime.truncate(date, :second) |> Calendar.strftime("%b-%d %H:%M Z")
    end
  end

  def get_tz(socket) do
    Phoenix.LiveView.get_connect_params(socket)["tz"] || "Etc/UTC"
  end

  def sec_to_str(secs) when secs < 0 do
    "<#{Util.Seconds.to_s(secs)}>"
  end

  def sec_to_str(secs) do
    "#{Util.Seconds.to_s(secs)}"
  end

  def title(secs) do
    str = secs |> sec_to_str()
    "Domo #{str}"
  end

end
