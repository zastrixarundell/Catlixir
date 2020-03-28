# Catlixir
A discord bot written in Elixir for... Cats!
![Catlixir image](https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/catlixir.png "Catlixir")

[![Discord server badge](https://img.shields.io/discord/602112468961067011)](https://discord.gg/MdASH22) ![Github release](https://img.shields.io/github/v/release/zastrixarundell/catlixir)

## Usage - client side
This bot has multiple commands mostly regarding cats. Currently there are 6 commands.

* `.cat fact` - show a random fact about cats.
* `.cat breed (name)` - show details about a specified breed or show a random breed depending if name is specified.
* `.cat random` - get a random cat image.
* `.cat invite` - invite the bot to a discord server.
* `.cat support` - join the support server.
* `.cat help` - show the help menu.

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
And you're good to go! The bot will start by itself.

## Configuration
If you're using the bot, you can use this pre-made configuration so save you time:
```elixir
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
```
Or if you want error to be raised in case some variables are not set:
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
```
