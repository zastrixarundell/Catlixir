defmodule Catlixir.Command.Meme do
  @behaviour Catlixir.Command

  @moduledoc """
  Module representing the meme Discord command
  """

  import Catlixir.Helper

  def perform(_arguments, message) do

    alias Nostrum.Api

    case get_meme(message) do
      {:ok, embed} ->
        message.channel_id
        |> Api.create_message(embed: embed)

      {:error, :not_a_meme} ->
        perform(nil, message)

      {:error, :"404"} ->
        message.channel_id
        |> Api.create_message(embed: create_api_error_embed!(message))

      {:error, _else} ->
        message.channel_id
        |> Api.create_message(embed: create_error_embed!(message))
    end

    :ok
  end

  def get_meme(message) do
    url =
      "https://www.reddit.com/r/catmeme/random.json"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 302, headers: headers}} ->
        {status, embed} =
          headers
          |> Enum.map(fn {key, value} -> {"#{key}" |> String.to_atom(), value} end)
          |> Keyword.get(:location)
          |> get_data_for_location!()
          |> create_meme_embed!(message)

        if status == :error do
          {:error, :not_a_meme}
        else
          {:ok, embed}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :"404"}

      {:error, _error} ->
        {:error, :else}
    end
  end

  def get_data_for_location!(location) do
    case HTTPoison.get(location) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          body
          |> Jason.decode!()
      _ -> nil
    end
  end

  def create_meme_embed!(json, message) do
    import Nostrum.Struct.Embed

    json =
      if is_list(json), do: List.first(json), else: json

     json =
      json
      |> Map.get("data")
      |> Map.get("children")
      |> List.first()
      |> Map.get("data")

    type = json["post_hint"] || ""
    link = json["permalink"] || ""

    status = if type != "image" or link == "" do
      :error
    else
      :ok
    end

    embed =
      %Nostrum.Struct.Embed{}
      |> put_title(json["title"])
      |> put_image(json["url"])
      |> put_url("https://www.reddit.com#{link}")
      |> put_footer("u/#{json["author"]}")
      |> put_color_on_embed(message)

    {status, embed}
  end


end
