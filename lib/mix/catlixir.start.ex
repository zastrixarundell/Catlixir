defmodule Mix.Tasks.Catlixir.Start do
  use Mix.Task

  @moduledoc """
  Starts the Discord bot with `--no-halt` automatically added!
  """

  @doc false
  def run(args) do
    Application.put_env(:catlixir, :process, true, persistent: true)
    Mix.Tasks.Run.run ["--no-halt"] ++ args
  end

end
