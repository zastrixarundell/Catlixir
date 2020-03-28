defmodule Catlixir.Command.Support do
  @behaviour Catlixir.Command

  @doc false
  def perform(_arguments, message) do
    alias Nostrum.Api

    Api.create_message(message.channel_id, embed: create_support_embed(message))
    :ok
  end

  @support_url Application.get_env(:catlixir, :support_url)

  @doc """
  Creates an embed for the support link.
  """
  def create_support_embed(message) do
    import Nostrum.Struct.Embed
    import Catlixir.Helper

    %Nostrum.Struct.Embed{}
    |> put_title("Go to the support server!")
    |> put_description("You can go to the support server by following [this](#{@support_url}) link!")
    |> put_color_on_embed(message)
  end
end
