defmodule DomoWeb.Test1Live do

  use Phoenix.LiveView
  alias Domo.Ctx.Accounts

  # ----- lifecycle callbacks
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    {
      :ok,
      assign(
        socket,
        session_id: session["live_socket_id"],
        current_user: user
      )
    }
  end

end
