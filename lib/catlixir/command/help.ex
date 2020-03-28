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

  @command Application.get_env(:catlixir, :command)

  @doc """
  Generates a nostrum embed which contains all of the commands which
  this bot has.
  """
  def generate_help_embed!(message) do
    import Nostrum.Struct.Embed
    import Catlixir.Helper

    me = Nostrum.Cache.Me.get()

    avatar_url =
      "https://cdn.discordapp.com/avatars/#{me.id}/#{me.avatar}.png"

    {:ok, vsn} = :application.get_key(:catlixir, :vsn)

    %Nostrum.Struct.Embed{}
    |> put_title("Co-meow-nds for: #{me.username}!")
    |> put_thumbnail(avatar_url)
    |> put_field("#{@command} fact", "Get a random fact about us (cats)!")
    |> put_field("#{@command} breed (name)", "Get info about a breed. If the name is not specified, it will return a random breed.")
    |> put_field("#{@command} random", "Get a random image of a cat!")
    |> put_field("#{@command} invite", "Invite the bot to your server!")
    |> put_field("#{@command} invite", "Go to the support server!")
    |> put_field("#{@command} help", "Show this menu!")
    |> put_footer("Current version: #{vsn |> List.to_string()}")
    |> put_color_on_embed(message)
  end
end
