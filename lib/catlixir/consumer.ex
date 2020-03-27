defmodule Catlixir.Consumer do
  @moduledoc """
  Module which is the Discord consumer. This handles all of the events
  for the bot and then continues with the rest of the logic depending
  on the event and result.

  This does not directly send messages, it is only a parser.
  """

  use Nostrum.Consumer

  @doc false
  def start_link do
    Consumer.start_link(__MODULE__)
  end

  @command Application.get_env(:catlixir, :command)

  @doc """
  Handles the `:MESSAGE_CREATE` event. If it is
  seen as a command crated from an user, it will
  parse it to the command module.
  """
  def handle_event({:MESSAGE_CREATE, message, _ws_state}) do
    if (!message.author.bot and is_catlixir_command? message), do:
      Catlixir.Command.handle_message(message)
  end

  @doc """
  Listen to ready event and update the status.
  """
  def handle_event({:READY, _, _}) do
    Nostrum.Api.update_status("", "you type #{@command}", 3)
  end


  @doc """
  This only exists so that when an uncaptured event is
  created the bot won't create an error!
  """
  def handle_event(_event) do
    :noop
  end

  @spec is_catlixir_command?(any()) :: boolean()
  defp is_catlixir_command?(message) do
    message.content
      |> String.downcase()
      |> String.starts_with?(@command)
  end
end
