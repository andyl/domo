defmodule Domo.Interval do

  def all do
    [
      %{
        text: "25 mins",
        label: "tomato task",
        seconds: 1500
      },
      %{
        text: "15 mins",
        label: "long break - after 4 tasks",
        seconds: 900
      },
      %{
        text: "5 mins",
        label: "short break - between tasks",
        seconds: 300
      },
      %{
        text: "5 secs",
        label: "test",
        seconds: 5
      },
    ]
  end

  def short_label(txt) do
    txt
    |> String.split(" - ")
    |> List.first()
  end

  def short_label(txt, _default) when is_binary(txt) do
    txt |> short_label()
  end

  def short_label(map, _default) when is_map(map) do
    map.label |> short_label()
  end

  def short_label(nil, default_secs) do
    default_secs
    |> Util.Seconds.to_s()
  end

  def interval_for(secs) do
    secs
    |> Enum.find(fn(map) -> map.seconds == secs end)
  end

  def short_label_for(secs) do
    all()
    |> Enum.find(fn(map) -> map.seconds == secs end)
    |> short_label(secs)
  end

end
