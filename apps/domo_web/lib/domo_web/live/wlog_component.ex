defmodule DomoWeb.WlogComponent do
  use Phoenix.Component

  def start_link(%{mins: a_mins} = assigns) do
    mins = a_mins |> String.to_integer()
    secs = mins * 60
    ~H"""
    <div style="text-align: center;">
      <a href="#" phx-click="start-period" phx-value-secs={secs}>
        <%= mins %> mins
      </a>
      <br/>
      <small><%= @label %></small>
    </div>
    """
  end

  def start_link(%{secs: a_secs} = assigns) do
    secs = a_secs |> String.to_integer()
    ~H"""
    <div style="text-align: center;">
      <a href="#" phx-click="start-period" phx-value-secs={secs}>
        <%= secs %> secs
      </a>
      <br/>
      <small><%= @label %></small>
    </div>
    """
  end

end
