use Mix.Config

# Configuration for Nostrum
shards =
  System.get_env("DISCORD_BOT_SHARDS", "-1")
  |> String.to_integer()

token =
  System.get_env("DISCORD_BOT_TOKEN")

config :nostrum,
  token: token,
  num_shards: if shards != -1, do: shards, else: :auto

# Configuration for Catlixir
the_cat_api_key =
  System.get_env("THE_CAT_API_KEY")

config :catlixir,
  command: System.get_env("DISCORD_BOT_COMMAND") || ".cat",
  the_cat_api_key: the_cat_api_key,
  invite_url: System.get_env("DISCORD_BOT_INVITE_URL"),
  support_url: System.get_env("DISCORD_BOT_SUPPORT")

# Configuration for DiscordBotList
config :discord_bot_list,
  id: System.get_env("DBL_ID"),
  token: System.get_env("DBL_TOKEN")

config :catlixir, Catlixir.Scheduler,
  jobs: [
    {"* * * * *", &Catlixir.Scheduler.update_dbl_status/0}
  ]
