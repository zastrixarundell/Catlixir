defmodule Catlixir do

  @moduledoc """
  Module for the basic API of Catlixir.
  """

  @doc """
  Get the server/guild count in which the bot is currently in.
  """
  def get_server_count! do
    Nostrum.Cache.GuildCache.all()
    |> Enum.count()
  end

  @doc """
  Show the amount of unique non-bot users in the guilds the bot is in across.
  """
  @spec get_user_count!() :: non_neg_integer()
  def get_user_count! do
    Nostrum.Cache.GuildCache.all()
    |> Stream.flat_map(fn guild -> guild.members end)
    |> Stream.reject(fn {_, member} -> member.user.bot end)
    |> Stream.uniq_by(fn {snowflake, _} -> snowflake end)
    |> Enum.count()
  end

  alias Nostrum.Cache.Me

  @doc """
  Get the url of the avatar image which the bot currently has.
  """
  def get_avatar_url! do
    Me.get()
    |> Nostrum.Struct.User.avatar_url()
  end

  @doc """
  Get the username of the bot without the discriminator.
  """
  def get_username!, do: Me.get().username

  @doc """
  Get the discriminator of the bot.
  """
  def get_discriminator!, do: Me.get().discriminator

  @doc """
  Get the full username with discriminator of the bot.
  """
  def get_full_name! do
    Me.get()
    |> Nostrum.Struct.User.full_name()
  end

  @command_prefix Application.get_env(:catlixir, :command)

  @doc """
  Get the command prefix which the bot uses.
  """
  def get_command_prefix!, do: @command_prefix

  @doc """
  Get the `String.t()` version of the bot version.
  """
  def get_version! do
    {:ok, vsn} = :application.get_key(:catlixir, :vsn)
    List.to_string(vsn)
  end

end
