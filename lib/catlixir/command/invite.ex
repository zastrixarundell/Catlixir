defmodule Catlixir.Command.Invite do
  @behaviour Catlixir.Command

  @moduledoc """
  Module representing the invite command on the bot.
  """

  @doc false
  def perform(_arguments, message) do
    alias Nostrum.Api

    Api.create_message(message.channel_id, embed: create_invite_embed(message))
    :ok
  end

  @invite_url Application.get_env(:catlixir, :invite_url)

  @doc """
  Creates an embed for the invite link to add the bot to any server.
  """
  def create_invite_embed(message) do
    import Nostrum.Struct.Embed
    import Catlixir.Helper

    my_username = Nostrum.Cache.Me.get().username

    create_empty_embed!(message)
    |> put_title("Invite #{my_username} to your server!")
    |> put_description(
      "You can go to [this](#{@invite_url}) url to invite the bot to your server!"
    )
  end
end
