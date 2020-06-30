defmodule Catlixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

    children =
      if Application.get_env(:catlixir, :process, false) do
        [
          # I need to add listeners here
          Catlixir.Consumer,
          Catlixir.Scheduler
        ]
      else
        [
          Catlixir.Consumer
        ]
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Catlixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
