defmodule Catlixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # I need to add listeners here
      Catlixir.Consumer,
      Catlixir.Scheduler,
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: CatlixirWeb.Endpoint,
        options: [port: Application.get_env(:catlixir, :port) |> String.to_integer()]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Catlixir.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
