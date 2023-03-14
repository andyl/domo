defmodule Termato.Timer do

  @moduledoc """
  The Timer coordinates the activities of the Counter and Clients.
  """

  use Task

  alias Termato.Counter
  alias DomoWeb.Sockets.CounterHandler

  # ----- STARTUP -----

  def start_link(_) do
    Task.start_link(fn -> loop() end)
  end

  # ----- LOOP -----

  defp loop do

    Counter.decrement()

    CounterHandler.broadcast("TICK", Counter.get_secs())

    Process.sleep(1000)

    loop()
  end

end
