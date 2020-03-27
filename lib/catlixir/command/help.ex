defmodule Catlixir.Command.Help do
  @behaviour Catlixir.Command
  alias Nostrum.Api

  @moduledoc """
  Elixir module which corresponds to the `help` command on the bot.
  """

  def perform(_arguments, message) do
    Api.create_message(message.channel_id, "So, why did you write help?")
    :ok
  end
end
