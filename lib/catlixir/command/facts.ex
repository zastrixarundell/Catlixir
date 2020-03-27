defmodule Catlixir.Command.Facts do
  @behaviour Catlixir.Command
  alias Nostrum.Api

  def perform(_arguments, message) do
    Api.create_message(message.channel_id, "So, why did you write facts?")
    :ok
  end
end
