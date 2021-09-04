# Catlixir
A discord bot written in Elixir for... Cats!

![Catlixir image](https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/catlixir_banner.png "Catlixir")

[![Discord server badge](https://img.shields.io/discord/602112468961067011)](https://discord.gg/MdASH22) [![Server count](https://img.shields.io/endpoint?url=https%3A%2F%2Fcatlixir.herokuapp.com%2Fapi%2Fshield%2Fservers)](https://discordapp.com/api/oauth2/authorize?client_id=641309305227837440&permissions=0&scope=bot) [![User count](https://img.shields.io/endpoint?url=https%3A%2F%2Fcatlixir.herokuapp.com%2Fapi%2Fshield%2Fusers)](](https://discordapp.com/api/oauth2/authorize?client_id=641309305227837440&permissions=0&scope=bot)) ![Elixir version](https://img.shields.io/endpoint?url=https%3A%2F%2Fcatlixir.herokuapp.com%2Fapi%2Fshield%2Felixir) ![Github release](https://img.shields.io/github/v/release/zastrixarundell/catlixir)

## Usage - client side
This bot has multiple commands mostly regarding cats. Here are the commands:

|Name|Usage|Description|
|----|-----|-----------|
|A cat fact|.cat fact|Show a random fact about cats.|
|Breed info|.cat breed york chocolate|Get the breed info about York Chocolates.|
|A random breed|.cat breed|Get a random breed and info about said breed.|
|Random image|.cat random|Get a random cat image from `r/cat`.|
|Random meme|.cat meme|Get a random cat meme from `r/Catmeme`.|
|Invite|.cat invite|Get the invite link for the bot.|
|Support|.cat support|Get the link for the support server.|
|Vote|.cat vote|Go to the vote url on top.gg!|
|Source|.cat source|See the source code.|
|Help|.cat help|Show the help menu.

All of the data is from remote APIs so be sure to check out the source code and see how to use those APIs for your own projects!

## Usage - server side
This bot can run independently by itself. You need to setup some system environments which are explained in the `config.exs`. 

To start it you just need to do:
* `mix catlixir.start`

And watch the magic happen!

## Installation

Catlixir can as well run as a part of your application (tested on Phoenix). For now you can get the dependency via github!
```elixir
def deps do
  [
    # ...
    {:catlixir, git: "https://github.com/zastrixarundell/Catlixir"}
  ]
end
```
And you're good to go! The bot will start by itself. You can see how [CatlixirWeb](https://github.com/zastrixarundell/CatlixirWeb) is using it.

## Configuration
If you're using the bot, you can use this pre-made configuration so save you time:
```elixir
# Configuration for Nostrum
config :nostrum,
  token: System.get_env("DISCORD_BOT_TOKEN"),
  num_shards: System.get_env("DISCORD_BOT_SHARDS") |> String.to_integer()

# Configuration for Catlixir
config :catlixir,
  command: System.get_env("DISCORD_BOT_COMMAND") || ".cat",
  the_cat_api_key: System.get_env("THE_CAT_API_KEY"),
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
```
Or if you want to have checks in the config:
```elixir
# Configuration for Nostrum
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

# Configuration for Catlixir
the_cat_api_key =
  System.get_env("THE_CAT_API_KEY") ||
    raise """
    The cat api key not found!
    Get one for free at: https://thecatapi.com/
    """

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
```
