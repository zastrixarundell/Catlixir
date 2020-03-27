defmodule Catlixir.Command do
  @moduledoc """
  Module represting a Discord command used for this bot.
  """

  @doc """
  Handles all of the message and sends them to the
  required command modules
  """
  def handle_message(message) do

    alias Nostrum.Api
    Api.create_message!(message.channel_id, "Cat command spotted!")
  end

end
