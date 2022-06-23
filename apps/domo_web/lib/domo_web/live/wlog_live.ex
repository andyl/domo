defmodule DomoWeb.WlogLive do

  use DomoWeb, :live_view
  alias Domo.Accounts

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
