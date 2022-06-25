defmodule Domo.Zcount do

  @moduledoc """
  Domo.Counter

  What it does:
  - starts an agent, attached to the user_id
  - once per second:
    - increment the counter
    - send update to PubSub
  """

  @doc """
  dc_start

  Generate a new DomoCounter populated with a start count.
  """
  def dc_start(user_id, count) do
    case alive?(user_id) do
      true -> dc_put(user_id, count)
      false -> dc_new(user_id, count)
    end
  end

  def dc_get(name) do
    vianame = vianame(name)
    Agent.get(vianame, &(&1))
  end

  def dc_put(user_id, count) do
    name = vianame(user_id)
    Agent.update(name, fn(_) -> count end)
  end

  def dc_dec(user_id) do
  end

  # --------------------------------------------------------

  defp dc_new(user_id, count) do
    vianame = vianame(user_id)
    Agent.start_link(fn() -> count end, name: vianame)
    user_id
  end

  defp agent_pid(userid) do
    case Registry.lookup(Domo.Registry, to_name(userid)) do
      [] -> nil
      list -> list |> List.first() |> elem(0)
    end
  end

  defp alive?(userid) do
    case agent_pid(userid) do
      nil -> false
      pid -> pid |> Process.alive?()
    end
  end

  defp vianame(userid) do
    name = to_name(userid)
    {:via, Registry, {Domo.Registry, name}}
  end

  defp to_name(name) when is_integer(name) do
    name |> Integer.to_string()
  end

  defp to_name(name) when is_binary(name) do
    name
  end

end
