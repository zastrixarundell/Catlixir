defmodule Catlixir.Helper do
  @moduledoc """
  Module containing general helper functions.
  """

  @doc """
  Puts a color on the embed. The color is the primary
  color of the role which the bot has in a channel.
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

  @doc """
  Generates a nostrum embed for an event if the api has an error 404.
  """
  def create_api_error_embed!(message) do
    import Nostrum.Struct.Embed

    %Nostrum.Struct.Embed{}
    |> put_title("Oh noes! The page wasn't found!")
    |> put_description("The page from where I get the facts is down! This is a cat-astrophe!")
    |> put_image("https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/oh_noes.jpg")
    |> put_color_on_embed(message)
  end

  @doc """
  Generates a nostrum embed for an event if the api has an error
  which is not 404.
  """
  def create_error_embed!(message) do
    import Nostrum.Struct.Embed

    %Nostrum.Struct.Embed{}
    |> put_title("Oh noes! The an error meow-curred!")
    |> put_description("Something went wrong hooman!")
    |> put_image("https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/oh_noes.jpg")
    |> put_color_on_embed(message)
  end

end
