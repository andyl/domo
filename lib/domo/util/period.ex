defmodule Util.Period do
  def first?(periods, period) do
    List.first(periods) == period
  end

  def unfirst?(periods, period) do
    ! first?(periods, period)
  end

  def last?(periods, period) do
    List.last(periods) == period
  end

  def unlast?(periods, period) do
    ! last?(periods, period)
  end

  def next(periods, period) do
    if last?(periods, period) do
      nil
    else
      case idx_of(periods, period) do
        nil -> nil
        val -> Enum.at(periods, val + 1)
      end
    end
  end

  def prev(periods, period) do
    if first?(periods, period) do
      nil
    else
      case idx_of(periods, period) do
        nil -> nil
        val -> Enum.at(periods, val - 1)
      end
    end
  end

  def changeset(nil) do
    nil
  end

  def changeset(period) do
    Domo.Sch.Users.Period.changeset(period, %{})
  end

  def changeset(nil, _attrs) do
    nil
  end

  def changeset(period, attrs) do
    Domo.Sch.Users.Period.changeset(period, attrs)
  end

  defp idx_of(periods, period) do
    Enum.find_index(periods, fn x -> x == period end)
  end
end
