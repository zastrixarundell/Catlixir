defmodule Catlixir.Command do
  @moduledoc """
  Module representing discord commands.
  """

  @command_prefix Catlixir.get_command_prefix!()

  @doc """
  Handles all of the message and sends them to the
  required command modules
  """
  def handle_message(message) do
    {command, arguments} =
      message.content
      |> String.replace_prefix(@command_prefix, " ")
      |> String.trim_leading()
      |> String.downcase()
      |> String.split(" ")
      |> List.pop_at(0)

    alias Catlixir.Command.{
      Help,
      Fact,
      Breed,
      Invite,
      Support,
      RedditPost,
      Vote,
      Source
    }

    case command do
      "help" ->
        Help.perform(arguments, message)

      "fact" ->
        Fact.perform(arguments, message)

      "breed" ->
        Breed.perform(arguments, message)

      "random" ->
        RedditPost.perform("cat", message)

      "invite" ->
        Invite.perform(arguments, message)

      "support" ->
        Support.perform(arguments, message)

      "meme" ->
        RedditPost.perform("catmemes", message)

      "vote" ->
        Vote.perform(arguments, message)

      "source" ->
        Source.perform(arguments, message)

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
