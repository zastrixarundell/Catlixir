defmodule Catlixir.Consumer do
  @moduledoc """
  Module which is the Discord consumer. Can be said this is the
  main module for the Discord bot.
  """

  use Nostrum.Consumer

  alias Nostrum.Api

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event(event) do
    IO.inspect event
    :noop
  end
end
