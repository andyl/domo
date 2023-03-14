defmodule DomoWeb.WlogLive do
  use DomoWeb, :live_view

  alias Domo.Counter
  alias Domo.Ctx
  import DomoWeb.WlogComponent
  # import DomoWeb.LiveHelpers
  #
  # alias DomoWeb.Router.Helpers, as: Routes
  #
  # # ----- lifecycle callbacks
  def mount(_params, session, socket) do
    user = Ctx.Accounts.get_user_by_session_token(session["user_token"])
    uid = user.id |> Integer.to_string()
    periods = Ctx.Users.get_user_periods(user.id)

    Phoenix.PubSub.subscribe(Domo.PubSub, uid)

    opts = %{
        tz: get_tz(socket),
        sec_str: "",
        sec_klas: nil,
        s_count: 0,
        page_title: "Domo",
        session_id: session["live_socket_id"],
        periods: periods,
        edit_period: nil,
        current_user: user
    }

    {:ok, assign(socket, opts)}
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

  # ---- render

  def render(assigns) do
    ~H"""
    <div>
      <section
        class="container"
        style="padding: 10px; background-color: lightgray; display: flex; justify-content: space-between; align-items: center;"
      >
        <%= for int <- Domo.Util.Interval.all() do %>
          <.start_link text={int.text} label={int.label} secs={int.seconds} />
        <% end %>
      </section>

      <section class="container">
        <table>
          <thead>
            <tr>
              <th>#</th>
              <th>period</th>
              <th>headline</th>
              <th>started at</th>
              <th>status</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            <%= for p <- @periods do %>
              <tr>
                <td><%= p.sequence %></td>
                <td><%= p.seconds |> Domo.Util.Interval.short_label_for() %></td>
                <td><%= p.headline || "na" %><%= DomoWeb.WlogLive.note_tag(p.notes) %></td>
                <td><%= p.inserted_at |> DomoWeb.WlogLive.ldate(@tz) %></td>
                <td><%= p.status %></td>
                <td></td>
              </tr>
            <% end %>
          </tbody>
        </table>
      </section>
    </div>
    """
  end

  # ----- event handlers

  def handle_event("start-period", %{"secs" => dsecs} = _data, socket) do
    secs = dsecs |> String.to_integer()
    cuid = socket.assigns[:current_user].id

    Ctx.Users.start_user_period(cuid, secs)
    Counter.start(cuid, secs)

    periods = Ctx.Users.get_user_periods(cuid)

    {:noreply, assign(socket, :periods, periods)}
  end

  # ----- message handlers

  def handle_info({"tick", secs}, socket) do
    oldklas = socket.assigns.sec_klas
    newklas = secs |> Util.Seconds.klas()

    if oldklas != newklas do
      send(self(), {"newfav", newklas})
    end

    opts = [
      s_count: secs,
      sec_str: sec_to_str(secs),
      sec_klas: newklas,
      page_title: title(secs)
    ]

    {:noreply, assign(socket, opts)}
  end

  def handle_info({"newfav", newklas}, socket) do
    {:noreply, push_event(socket, "newfav", %{color: newklas})}
  end

  # ----- view helpers

  def note_tag(nil), do: ""
  def note_tag(""), do: ""
  def note_tag(_), do: " <N>"

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
