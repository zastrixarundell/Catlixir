defmodule CatlixirWeb.Api.DataResponse do
  @moduledoc """
  Behaviour module for a shield controller.
  """

  @callback data :: Map.t()

  defmacro __using__(_) do
    quote do
      import Plug.Conn

      def show(conn) do
        conn
        |> send_resp(200, data() |> Poison.encode!())
      end

      @behaviour CatlixirWeb.Api.DataResponse
    end
  end
end
