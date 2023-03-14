defmodule Domo.Counter do
  use GenServer

  # ----- startup

  def start_link do
    start_link(%{})
  end

  def start_link([]) do
    start_link(%{})
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, [name: __MODULE__])
  end

  # ----- api

  def decrement do
    GenServer.cast(__MODULE__, "decrement")
  end

  def reset do
    GenServer.cast(__MODULE__, "reset")
  end

  def start(user_id, secs) do
    tid = user_id |> to_str()
    GenServer.call(__MODULE__, {"start", tid, secs})
  end

  def get do
    GenServer.call(__MODULE__, "get")
  end

  def get(user_id) do
    tid = user_id |> to_str()
    GenServer.call(__MODULE__, {"get", tid})
  end

  def put(user_id, secs) do
    tid = user_id |> to_str()
    GenServer.call(__MODULE__, {"put", tid, secs})
  end

  # ----- lifecycle callbacks

  def init(state) do
    :timer.apply_interval(1000, __MODULE__, :decrement, [])
    {:ok, state}
  end

  def handle_cast("decrement", state) do
    new_state =
      state
      |> Enum.reduce(%{}, fn {k, v}, acc -> Map.merge(acc, %{k => v - 1}) end)

    new_state
    |> Enum.each(fn({k, v}) -> broadcast(k, v) end)

    {:noreply, new_state}
  end

  def handle_cast("reset", _state) do
    {:noreply, %{}}
  end

  def handle_call({"start", user_id, count}, _from, state) do
    new_state = state |> Map.merge(%{user_id => count})
    {:reply, :ok, new_state}
  end

  def handle_call("get", _from, state) do
    {:reply, state, state}
  end

  def handle_call({"get", user_id}, _from, state) do
    val = Map.get(state, user_id)
    {:reply, val, state}
  end

  def handle_call({"put", user_id, count}, _from, state) do
    new_state = state |> Map.merge(%{user_id => count})
    {:reply, :ok, new_state}
  end

  # ----- helpers

  defp alert do
    Task.async(fn -> System.cmd("play", ["ring", "&"]) ; Process.sleep(1000); end)
  end

  defp broadcast(userid, secs) do
    if secs == 0, do: alert()
    Phoenix.PubSub.broadcast(Domo.PubSub, userid, {"tick", secs})
  end

  defp to_str(name) when is_integer(name) do
    name |> Integer.to_string()
  end

  defp to_str(name) when is_binary(name) do
    name
  end

end
