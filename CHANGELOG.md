# Changelog

# 0.1.9
- Added a application variable in the mix task to not start the discord bot listener process when a non-bot process is start. Example: `iex -S mix` won't start a new discord bot causing multiple messages to be sent at the same command call.

# 0.1.8
- Using default ID for vote command.

# 0.1.7
- Added source command.
- Using create universal function for color embeds in Helper.

# 0.1.6
- Using DiscordBotList
- Added `Vote` command.

# 0.1.5
- Fixed typo on error message.
- Using custom `User-agent` header with Reddit.

# 0.1.4
- Removed `Catlixir.Command.Random` module. 
- Started using `Catlixir` module.

# 0.1.3
- Using `RedditPost` module to get memes and random images.

## 0.1.2
- Added meme command.
- Added changelog.

## 0.1.1
- Initial version used in production.