defmodule Catlixir.Helper do
  @moduledoc """
  Module containing general helper functions.
  """

  def put_color_on_embed(embed, message) do
    guild =
      message.guild_id
      |> Nostrum.Cache.GuildCache.get()

    case guild do
      {:ok, guild} ->

        role_id =
          guild
          |> Map.get(:members)
          |> Map.get(Nostrum.Cache.Me.get().id)
          |> Map.get(:roles)
          |> Enum.at(0)

        role =
          guild
          |> Map.get(:roles)
          |> Map.get(role_id)

        if role == nil do
          embed
        else
          import Nostrum.Struct.Embed

          embed
          |> put_color(role.color)
        end
      {:error, _reason} ->
        embed
    end
  end

end
