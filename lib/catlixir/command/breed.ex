defmodule Catlixir.Command.Breed do
  @behaviour Catlixir.Command

  def perform(arguments, _message) do
    IO.inspect(arguments)
    :ok
  end
end
