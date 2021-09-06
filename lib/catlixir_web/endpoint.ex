defmodule CatlixirWeb.Endpoint do
  use Plug.Router

  @moduledoc """
  Minimalistic endpoint for this bot.
  """

  # Using Plug.Loader for logging request informaiton
  plug(Plug.Logger)

  # Always want to reiforce SSL on forwarded.
  plug(Plug.SSL, rewrite_on: [:x_forwarded_proto], host: nil)

  # Resonsible for endpoint mattching
  plug(:match)
  # JSON parse library
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  # Set every response to be `application/json`
  plug(CatlixirWeb.Plugs.JsonRequestPlug)
  # Responsible for dispatching responses
  plug(:dispatch)

  get "/api/shields/guilds" do
    apply(CatlixirWeb.Controllers.Api.Shields.Guilds, :show, [conn])
  end

  get "/api/shields/system" do
    apply(CatlixirWeb.Controllers.Api.Shields.System, :show, [conn])
  end

  get "/api/shields/users" do
    apply(CatlixirWeb.Controllers.Api.Shields.Users, :show, [conn])
  end

  match _ do
    send_resp(conn, 404, "{\"error\": \"Path Undefined\"}")
  end
end
