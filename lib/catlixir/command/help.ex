defmodule Catlixir.Command.Help do
  @behaviour Catlixir.Command

  @moduledoc """
  Elixir module which corresponds to the `help` command on the bot.
  """

  @doc false
  def perform(_arguments, message) do
    alias Nostrum.Api

    Api.create_message(message.channel_id, embed: generate_help_embed!(message))
    :ok
  end

  @command Catlixir.get_command_prefix!()

  @doc """
  Generates a nostrum embed which contains all of the commands which
  this bot has.
  """
  def generate_help_embed!(message) do
    import Nostrum.Struct.Embed
    import Catlixir.Helper

    %Nostrum.Struct.Embed{}
    |> put_title("Co-meow-nds for: #{Catlixir.get_username!()}!")
    |> put_thumbnail(Catlixir.get_avatar_url!())
    |> put_field("#{@command} fact", "Get a random fact about us (cats)!")
    |> put_field("#{@command} breed (name)", "Get info about a breed. If the name is not specified, it will return a random breed.")
    |> put_field("#{@command} random", "Get a random image from the `r/cat` subreddit!")
    |> put_field("#{@command} meme", "Get a random meme from the `r/Catmeme` subreddit!")
    |> put_field("#{@command} invite", "Invite the bot to your server.")
    |> put_field("#{@command} support", "Go to the support server.")
    |> put_field("#{@command} vote", "Vote for the bot on top.gg!")
    |> put_field("#{@command} help", "Show this menu.")
    |> put_footer("Current version: #{Catlixir.get_version!()}")
    |> put_color_on_embed(message)
  end
end
