use Mix.Config

# Configuration for the Discord used by nostrum
shards =
  System.get_env("DISCORD_BOT_SHARDS", "-1")
  |> String.to_integer()

config :nostrum,
  token: System.get_env("DISCORD_BOT_TOKEN"),
  num_shards: if shards != -1, do: shards, else: :auto
