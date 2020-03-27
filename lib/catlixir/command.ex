defmodule Catlixir.Command do
  @moduledoc """
  Module represting a Discord command used for this bot.
  """

  @doc """
  Handles all of the message and sends them to the
  required command modules
  """
  def handle_message(command_prefix, message) do
    alias Nostrum.Api

    content =
      message.content
      |> String.replace_prefix(command_prefix, " ")
      |> String.trim_leading()

    Api.create_message!(message.channel_id, "So, why did you write #{content}?")
  end

end
