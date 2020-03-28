defmodule Catlixir.Command.Breed do
  @behaviour Catlixir.Command

  @moduledoc """
  Module regarding the breed discord command.
  """

  @cat_api Application.get_env(:catlixir, :the_cat_api_key)
  import Catlixir.Helper

  alias Nostrum.Api

  @doc false
  def perform(arguments, message) do
    breed = Enum.join(arguments, " ")

    if breed != "" do
      result =
        breed
        |> create_url()
        |> HTTPoison.get(["x-api-key": @cat_api])

      case result do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          results =
            body
            |> Jason.decode!()

          IO.inspect json

          #message.channel_id
          #|> Api.create_message(embed: embed)

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          message.channel_id
          |> Api.create_message(embed: create_api_error_embed(message))

        {:error, _error} ->
          message.channel_id
          |> Api.create_message(embed: create_error_embed(message))
      end
    else

    end

    :ok
  end

  @doc """
  Creates a url to search about the specified breed.
  Encodes and creates the needed parameter.
  """
  def create_url(breed) do
    breed =
      breed
      |> URI.encode_www_form()

    "https://api.thecatapi.com/v1/breeds/search?q=#{breed}"
  end

end
