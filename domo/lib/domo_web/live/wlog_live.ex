defmodule DomoWeb.WlogLive do
  use DomoWeb, :live_view

  alias Domo.Counter
  alias Domo.Ctx
  # import DomoWeb.WlogComponent

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

  def handle_params(%{"edit" => pseq} = tgt, _uri, socket) do
    IO.inspect(tgt, label: "TGT")
    IO.inspect(pseq, label: "PSEQ")
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

  def handle_params(tgt, _uri, socket) do
    IO.inspect(tgt, label: "HPTGT")
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
      <div class={@sec_klas} style="margin-top: 20px; text-align: center;">
        <b>
          <%= @sec_str %>
        </b>
      </div>

      <section class="container bg-gray-200 flex p-2 items-center justify-between">
        <%= for int <- Domo.Util.Interval.all() do %>
          <.start_link text={int.text} label={int.label} secs={int.seconds} />
        <% end %>
      </section>

      <div class="mt-8 flow-root">
        <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
            <table class="min-w-full divide-y divide-gray-300">
              <thead>
                <tr>
                  <th scope="col" class="pl-3 text-left">#</th>
                  <th scope="col" class="pl-3 text-left">period</th>
                  <th scope="col" class="pl-3 text-left">headline</th>
                  <th scope="col" class="pl-3 text-left">started</th>
                  <th scope="col" class="pl-3 text-left">status</th>
                  <th scope="col" class="pl-3 text-left"></th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">
                <%= for p <- @periods do %>
                  <%= if @edit_period && @edit_period.id == p.id do %>
                    <.period_edit period={p} tz={@tz} changeset={@changeset} />
                  <% else %>
                    <.period_show period={p} tz={@tz} />
                  <% end %>
                <% end %>
              </tbody>
            </table>
          </div>
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
      <a class="text-blue-600" href="#" phx-click="start-period" phx-value-secs={@secs}>
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
      <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
        <%= @period.sequence %>
      </td>
      <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
        <%= @period.seconds |> Domo.Util.Interval.short_label_for() %>
      </td>
      <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
        <%= @period.headline || "na" %><%= DomoWeb.WlogLive.note_tag(@period.notes) %>
      </td>
      <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
        <%= @period.inserted_at |> DomoWeb.WlogLive.ldate(@tz) %>
      </td>
      <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
        <%= @period.status %>
      </td>
      <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
        <.link phx-click="edit_period" phx-value-pseq={@period.sequence}>
          <.icon name="hero-pencil-mini" class="hover:text-blue-500" />
        </.link>
        <.link phx-click="delete_period" phx-value-pseq={@period.sequence}>
          <.icon name="hero-trash-mini" class="hover:text-blue-500" />
        </.link>
      </td>
    </tr>
    """
  end

  attr :period, :map
  attr :changeset, :any
  attr :tz, :any

  def period_edit(assigns) do
    assigns = assign(assigns, :form, to_form(assigns[:changeset]))
    ~H"""
    <tr>
    <td class="bg-gray-200" colspan="6">
    <div class="text-center">
    #<%= @period.sequence %> |
    <%= @period.seconds |> Domo.Util.Interval.short_label_for() %> |
    <%= @period.inserted_at |> DomoWeb.WlogLive.ldate(@tz) %> |
    <%= @period.status %>
    </div>
    <div>
    <.simple_form for={@form} phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} label="Title"/>
        <.input field={@form[:notes]} type="textarea" label="Notes" />
        <.input field={@form[:project]} label="Project" />
        <.input field={@form[:tags]} label="Tags" />
        <:actions>
          <.button>Save</.button>
        </:actions>
    </.simple_form>
    <.button phx-click="cancel">Cancel</.button>
    </div>
    </td>
    </tr>
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

  def handle_event("edit_period", %{"pseq" => pseq}, socket) do
    opts = [{"edit", pseq}]
    {:noreply, push_patch(socket, to: ~p"/wlog?#{opts}")}
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
