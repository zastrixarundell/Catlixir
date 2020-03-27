use Mix.Config

# Configuration for the Discord used by nostrum
shards =
  System.get_env("DISCORD_BOT_SHARDS", "-1")
  |> String.to_integer()

token =
  System.get_env("DISCORD_BOT_TOKEN") ||
    raise """
    Discord bot token is not specified! You can create an app
    at https://discordapp.com/developers and then get the token
    of the created bot!
    """

config :nostrum,
  token: token,
  num_shards: if shards != -1, do: shards, else: :auto

config :catlixir,
  command: System.get_env("DISCORD_BOT_COMMAND") || ".cat"
