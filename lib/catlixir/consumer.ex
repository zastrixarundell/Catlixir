defmodule Catlixir.Consumer do
  @moduledoc """
  Module which is the Discord consumer. Can be said this is the
  main module for the Discord bot.
  """

  use Nostrum.Consumer

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, message, _ws_state}) do
    if !message.author.bot do
      start =
        message.content
        |> String.downcase()
        |> String.starts_with?(".cat")

      if start, do:
        Catlixir.Command.handle_message(message)
    end
  end

  def handle_event(_event) do
    :noop
  end
end
