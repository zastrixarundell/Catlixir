defmodule Catlixir.Command.Vote do
  @behaviour Catlixir.Command

  @moduledoc """
  Module corresponding to the Vote command.
  """

  @doc false
  def perform(_arguments, message) do
    alias Nostrum.Api

    Api.create_message(message.channel_id, embed: create_support_embed(message))
    :ok
  end

  @doc """
  Creates an embed for the vote link.
  """
  def create_support_embed(message) do
    import Nostrum.Struct.Embed
    import Catlixir.Helper

    id =
      DiscordBotList.get_single_bot().id

    boost =
      if DiscordBotList.weekend?(), do:
        "on",
      else:
        "off"


    %Nostrum.Struct.Embed{}
    |> put_title("Go to the support server!")
    |> put_description("You can go to and vote by following [this](https://top.gg/bot/#{id}/vote) link!")
    |> put_footer("Weekly boost is #{boost}")
    |> put_color_on_embed(message)
  end
end
