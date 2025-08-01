defmodule Expl.Feeds do
  def feed_from_key(key) do
    for {feed, conditions} <- config_feed_key_map(),
        Enum.all?(conditions, &String.contains?(key, &1)) do
      to_string(feed)
    end
  end

  defp config, do: Application.get_env(:expl, __MODULE__)
  defp config_feed_key_map, do: config()[:feed_key_map]
end
