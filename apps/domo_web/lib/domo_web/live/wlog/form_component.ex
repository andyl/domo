defmodule DomoWeb.WlogLive.FormComponent do
  use DomoWeb, :live_component

  alias Domo.UsersCtx

  # ----- lifecycle callbacks

  def update(%{period: period} = assigns, socket) do
    changeset = UsersCtx.period_changeset(period)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  # ----- event handlers

  def handle_event("validate", %{"period" => fields}, socket) do
    changeset =
      socket.assigns.period
      |> UsersCtx.period_changeset(fields)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"period" => fields}, socket) do
    period = socket.assigns.period
    UsersCtx.update_user_period(period.user_id, period.sequence, fields)
    {:noreply,
      socket
      |> put_flash(:info, "period updated successfully")
      |> push_redirect(to: socket.assigns.return_to)}
  end

  # ----- helpers

end
