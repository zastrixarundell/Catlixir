use Mix.Config

config :nostrum,
  token: System.get_env("DISCORD_BOT_TOKEN"),
  num_shards: :auto,
  request_guild_members: true,
  gateway_intents: [
    :guilds,
    :guild_members
  ]

# Configuration for Catlixir
the_cat_api_key = System.get_env("THE_CAT_API_KEY")

config :catlixir,
  command: System.get_env("DISCORD_BOT_COMMAND") || ".cat",
  the_cat_api_key: the_cat_api_key,
  invite_url: System.get_env("DISCORD_BOT_INVITE_URL"),
  support_url: System.get_env("DISCORD_BOT_SUPPORT"),
  port: System.get_env("PORT")

# Configuration for DiscordBotList
config :discord_bot_list,
  id: System.get_env("DBL_ID"),
  token: System.get_env("DBL_TOKEN")

config :catlixir, Catlixir.Scheduler,
  jobs: [
    {"* * * * *", &Catlixir.Scheduler.update_dbl_status/0}
  ]
