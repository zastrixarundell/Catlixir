defmodule Catlixir.Command do
  @moduledoc """
  Module representing discord commands.
  """

  @command_prefix Application.get_env(:catlixir, :command)
  alias Catlixir.Command.{Help, Fact}

  @doc """
  Handles all of the message and sends them to the
  required command modules
  """
  def handle_message(message) do
    arguments =
      message.content
      |> String.replace_prefix(@command_prefix, " ")
      |> String.trim_leading()
      |> String.downcase()
      |> String.split(" ")

    case Enum.at(arguments, 0) do
      "help" ->
        Help.perform(arguments, message)

      "fact" ->
        Fact.perform(arguments, message)

      _ ->
        Help.perform(arguments, message)
    end

    :ok
  end

  @doc """
  Default behavior for any discord command.
  """
  @callback perform(arguments :: list(String.t()), message :: %Nostrum.Struct.Message{}) :: :ok

end
