defmodule Catlixir.Command do
  @moduledoc """
  Module representing discord commands.
  """

  @doc """
  Handles all of the message and sends them to the
  required command modules
  """
  def handle_message(command_prefix, message) do
    arguments =
      message.content
      |> String.replace_prefix(command_prefix, " ")
      |> String.trim_leading()
      |> String.downcase()
      |> String.split(" ")

    alias Catlixir.Command

    case Enum.at(arguments, 0) do
      "help" ->
        # stuff regarding help
        Command.Help.perform(arguments, message)
      "fact" ->
        # Show a random cat fact
        Command.Fact.perform(arguments, message)
      _ ->
        # uncategorized, use help
        alias Nostrum.Api
        Api.create_message(message.channel_id, "Nani!")
    end

    :ok
  end

  @doc """
  Default behavior for any discord command.
  """
  @callback perform(arguments :: list(String.t()), message :: %Nostrum.Struct.Message{}) :: :ok

end
