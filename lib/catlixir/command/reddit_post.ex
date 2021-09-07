defmodule Catlixir.Command.RedditPost do
  @behaviour Catlixir.Command

  @moduledoc """
  Module representing a RedditPost command. This is used for images and memes
  as they are essentially the same API-wise.
  """

  import Catlixir.Helper

  @doc false
  def perform(subreddit, message) do
    alias Nostrum.Api

    case get_post(subreddit, message) do
      {:ok, embed} ->
        message.channel_id
        |> Api.create_message(embed: embed)

      {:error, :not_a_good_post} ->
        perform(subreddit, message)

      {:error, :"404"} ->
        message.channel_id
        |> Api.create_message(embed: create_api_error_embed!(message))

      {:error, _else} ->
        message.channel_id
        |> Api.create_message(embed: create_error_embed!(message))
    end

    :ok
  end

  @doc """
  Gets a image post from redit. Returns `{:ok, %Nostrum.Struct.Embed{}}` if the result
  is positive and returns
  * {:error, :not_a_good_post}
  * {:error, :"404"}
  * {:error, :else}
  if not.
  """
  def get_post(subreddit, message) do
    url = "https://www.reddit.com/r/#{subreddit}/random.json"

    headers = [
      "User-agent": "#{Catlixir.get_username!()} #{Catlixir.get_version!()}",
      Accept: "Application/json; Charset=utf-8"
    ]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 302, headers: headers}} ->
        {status, embed} =
          headers
          |> Map.new()
          |> Map.get("location")
          |> get_data_for_location!()
          |> create_image_embed!(message)

        if status == :error do
          {:error, :not_a_good_post}
        else
          {:ok, embed}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :"404"}

      {:error, _error} ->
        {:error, :else}
    end
  end

  @doc """
  Gets the data of the redit JSON location which was specified in a header.
  """
  def get_data_for_location!(location) do
    case HTTPoison.get(location) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        body
        |> Jason.decode!()

      _ ->
        nil
    end
  end

  @doc """
  Creates a image embed if a post contains an image. Retuns a touple of
  `{:ok, %Nostrum.Struct.Embed{}}` if it's correct. Returns
  `{:error, %Nostrum.Struct.Embed{}}` if not.
  """
  def create_image_embed!(json, message) do
    import Nostrum.Struct.Embed

    json =
      json
      |> List.wrap()
      |> List.first()
      |> Map.get("data")
      |> Map.get("children")
      |> List.first()
      |> Map.get("data")

    type = json["post_hint"] || ""
    link = json["permalink"] || ""

    status =
      if type != "image" or link == "" do
        :error
      else
        :ok
      end

    embed =
      create_empty_embed!(message)
      |> put_title(json["title"])
      |> put_image(json["url"])
      |> put_url("https://www.reddit.com#{link}")
      |> put_footer("u/#{json["author"]}")

    {status, embed}
  end
end
