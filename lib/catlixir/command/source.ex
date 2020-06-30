defmodule Catlixir.Command.Source do
  @moduledoc """
  Elixir module corresponding to the source command.
  """

  @behaviour Catlixir.Command

  @doc false
  def perform(_arguments, message) do
    import Catlixir.Helper
    import Nostrum.Struct.Embed

    embed =
      create_empty_embed!(message)
      |> put_title("See how I am made!")
      |> put_description("You can see some info about me on MeowHub -- erm... I mean GitHub [here](https://github.com/zastrixarundell/catlixir)!")

    Nostrum.Api.create_message(message.channel_id, embed: embed)

    :ok
  end

end
