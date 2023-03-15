defmodule DomoWeb.WlogLive do
  use DomoWeb, :live_view

  alias Domo.Counter
  alias Domo.Ctx

  # ----- lifecycle callbacks

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
      session_id: session["live_socket_id"],
      periods: periods,
      edit_period: nil,
      changeset: nil,
      current_user: user
    }

    {:ok, assign(socket, opts)}
  end

  def handle_params(%{"edit" => pseq}, _uri, socket) do
    uid = socket.assigns[:current_user].id
    iseq = String.to_integer(pseq)
    period = Ctx.Users.get_user_period(uid, iseq)

    opts =
      case period do
        nil ->
          %{}

        result ->
          %{
            edit_period: result,
            changeset: Domo.Sch.Users.Period.changeset(period, %{})
          }
      end

    {:noreply, assign(socket, opts)}
  end

  def handle_params(_tgt, _uri, socket) do
    opts = %{
      edit_period: nil,
      changeset: nil
    }

    {:noreply, assign(socket, opts)}
  end

  # ---- render

  def render(assigns) do
    ~H"""
    <div>
      <section class="container bg-gray-200 flex px-4 py-1 mt-2 items-center justify-between">
        <%= for int <- Domo.Util.Interval.all() do %>
          <.start_link text={int.text} label={int.label} secs={int.seconds} />
        <% end %>
      </section>

      <div class="mt-2 flow-root">
        <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
            <table class="min-w-full divide-y divide-gray-300">
              <thead>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <%= for p <- @periods do %>
                  <%= if @edit_period && @edit_period.id == p.id do %>
                    <.period_edit periods={@periods} period={p} tz={@tz} changeset={@changeset} />
                  <% else %>
                    <.period_show period={p} tz={@tz} />
                  <% end %>
                <% end %> </tbody> </table> </div>
        </div>
      </div>
    </div>
    """
  end

  # ----- local components

  attr :secs, :integer
  attr :text, :string
  attr :label, :string

  def start_link(assigns) do
    ~H"""
    <div style="text-align: center;">
      <a class="text-blue-600" href="#" phx-click="start_period" phx-value-secs={@secs}>
        <%= @text %>
      </a>
      <br />
      <small><%= @label %></small>
    </div>
    """
  end

  attr :period, :map
  attr :tz, :any

  def period_show(assigns) do
    ~H"""
    <tr class="hover:bg-gray-100">
      <.td_show period={@period}>
        <%= @period.sequence %>
      </.td_show>
      <.td_show period={@period}>
        <%= @period.seconds |> Domo.Util.Interval.short_label_for() %>
      </.td_show>
      <.td_show period={@period}>
        <%= @period.headline || "na" %><%= DomoWeb.WlogLive.note_tag(@period.notes) %>
      </.td_show>
      <.td_show period={@period}>
        <%= @period.inserted_at |> DomoWeb.WlogLive.ldate(@tz) %>
      </.td_show>
      <.td_show period={@period}>
        <%= @period.status %>
      </.td_show>
      <.td_show period={@period} noselect={true}>
        <.link phx-click="delete_period" phx-value-pseq={@period.sequence}>
          <.icon name="hero-trash-mini" class="hover:text-blue-500" />
        </.link>
      </.td_show>
    </tr>
    """
  end

  attr :period, :any, required: true
  attr :noselect, :boolean, default: false
  slot :inner_block, required: true
  def td_show(assigns) do
    opts = case assigns[:noselect] do
      true -> %{target: nil, pseq: nil}
      false -> %{target: "edit_period", pseq: assigns[:period].sequence}
    end
    assigns = assign(assigns, opts)
    ~H"""
    <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500"
        phx-click={@target} phx-value-pseq={@pseq}>
    <span class="hover:cursor-pointer"><%= render_block(@inner_block) %></span>
    </td>
    """
  end

  attr :periods, :any
  attr :period, :map
  attr :changeset, :any
  attr :tz, :any

  def period_edit(assigns) do
    assigns = assign(assigns, :form, to_form(assigns[:changeset]))

    ~H"""
    <tr>
      <td class="border-black p-2 border-2" colspan="6">
        <div class="flex">
          <div class="flex-1">
            <%= @period.sequence %>
            <button :if={Util.Period.unfirst?(@periods, @period)} phx-click="edit_prev">
              <.icon name="hero-arrow-up-mini" class="hover:text-blue-500"/>
            </button>
            <button :if={Util.Period.unlast?(@periods, @period)} phx-click="edit_next">
              <.icon name="hero-arrow-down-mini" class="hover:text-blue-500"/>
            </button>
          </div>
          <div class="flex-1 whitespace-nowrap">
            <%= @period.seconds |> Domo.Util.Interval.short_label_for() %> |
            <%= @period.inserted_at |> DomoWeb.WlogLive.ldate(@tz) %> |
            <%= @period.status %>
          </div>
          <div class="flex-1 text-right">
            <button phx-click="edit_cancel">
              <.icon name="hero-x-circle" class="hover:text-blue-500"/>
            </button>
          </div>
        </div>
        <div>
          <.simple_form for={@form} phx-change="validate" phx-submit="save">
            <.input field={@form[:title]} label="Title" />
            <.input field={@form[:notes]} type="textarea" label="Notes" />
            <.input field={@form[:project]} label="Project" />
            <.input field={@form[:tags]} label="Tags" />
            <:actions>
              <.button class="object-right">Save</.button>
            </:actions>
          </.simple_form>
        </div>
      </td>
    </tr>
    """
  end

  # ----- event handlers

  def handle_event("start_period", %{"secs" => dsecs} = _data, socket) do
    secs = dsecs |> String.to_integer()
    cuid = socket.assigns[:current_user].id

    Ctx.Users.start_user_period(cuid, secs)
    Counter.start(cuid, secs)

    periods = Ctx.Users.get_user_periods(cuid)
    period = List.first(periods)

    opts = %{
      periods: periods,
      edit_period: period,
      changeset: Util.Period.changeset(period)
    }

    newsock = assign(socket, opts)
    params = [{"edit", period.sequence}]

    {:noreply, push_patch(newsock, to: ~p"/wlog?#{params}")}
  end

  def handle_event("delete_period", %{"pseq" => pseq}, socket) do
    uid = socket.assigns.current_user.id
    Ctx.Users.delete_user_period(uid, pseq)

    opts = %{
      periods: Ctx.Users.get_user_periods(uid),
      edit_period: nil
    }

    {:noreply, assign(socket, opts)}
  end

  def handle_event("edit_period", %{"pseq" => pseq}, socket) do
    params = [{"edit", pseq}]
    {:noreply, push_patch(socket, to: ~p"/wlog?#{params}")}
  end

  def handle_event("edit_cancel", _data, socket) do
    {:noreply, push_patch(socket, to: ~p"/wlog")}
  end

  def handle_event("edit_next", _data, socket) do
    periods = socket.assigns.periods
    period  = socket.assigns.edit_period
    next = Util.Period.next(periods, period)
    params = [{"edit", next.sequence}]
    {:noreply, push_patch(socket, to: ~p"/wlog?#{params}")}
  end

  def handle_event("edit_prev", _data, socket) do
    periods = socket.assigns.periods
    period  = socket.assigns.edit_period
    prev = Util.Period.prev(periods, period)
    params = [{"edit", prev.sequence}]
    {:noreply, push_patch(socket, to: ~p"/wlog?#{params}")}
  end

  def handle_event("edit_save", data, socket) do
    IO.inspect("edit_save", label: "TARGET")
    IO.inspect(data, label: "DATA")
    {:noreply, socket}
  end

  def handle_event(target, data, socket) do
    IO.inspect(target, label: "TARGET")
    IO.inspect(data, label: "DATA")
    {:noreply, socket}
  end

  # ----- message handlers

  def handle_info({"tick", secs}, socket) do
    oldklas = socket.assigns.sec_klas
    newklas = secs |> Util.Seconds.klas()

    if oldklas != newklas, do: send(self(), {"newfav", newklas})
    send(self(), {"newtitle", title(secs)})

    opts = [
      s_count: secs,
      sec_str: sec_to_str(secs),
      sec_klas: newklas
    ]

    {:noreply, assign(socket, opts)}
  end

  def handle_info({"newfav", newcolor}, socket) do
    {:noreply, push_event(socket, "newfav", %{color: newcolor})}
  end

  def handle_info({"newtitle", newtitle}, socket) do
    {:noreply, push_event(socket, "newtitle", %{title: newtitle})}
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
    "#{str} Domo"
  end
end
