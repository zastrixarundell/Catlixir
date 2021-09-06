defmodule CatlixirWeb.Controllers.Api.Shields.Users do
  use CatlixirWeb.Api.DataResponse

  def data do
    %{
      schemaVersion: 1,
      label: "Users",
      message: generate_user_data() |> to_string,
      color: "#7289DA",
      namedLogo: "Discord",
      style: "flat-square",
      logoColor: "#fff"
    }
  end

  @doc """
  Show the amount of unique non-bot users in the guilds the bot is in across.
  """
  @spec generate_user_data() :: non_neg_integer()
  def generate_user_data do
    Nostrum.Cache.GuildCache.all()
    |> Stream.flat_map(fn guild -> guild.members end)
    |> Stream.reject(fn {_, member} -> member.user.bot end)
    |> Stream.uniq_by(fn {snowflake, _} -> snowflake end)
    |> Enum.count()
  end
end
