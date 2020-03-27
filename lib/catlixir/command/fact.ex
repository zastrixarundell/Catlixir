defmodule Catlixir.Command.Fact do
  @behaviour Catlixir.Command

  @moduledoc """
  Elixir module which corresponds to the `fact` command on the bot.
  """

  @doc false
  def perform(_arguments, message) do
    alias Nostrum.Api

    case base_fact_url() |> HTTPoison.get() do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        embed =
          body
          |> Jason.decode!()
          |> create_fact_embed(message)

        message.channel_id
        |> Api.create_message(embed: embed)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        message.channel_id
        |> Api.create_message(embed: create_api_error_embed(message))

      {:error, _error} ->
        message.channel_id
        |> Api.create_message(embed: create_error_embed(message))
    end

    :ok
  end

  @doc """
  Gets the base url which should be used for the cat fact API.

  ## Examples

    iex> base_fact_url
    "https://catfact.ninja/fact"

  """
  @spec base_fact_url :: String.t()
  def base_fact_url do
    "https://catfact.ninja/fact"
  end

  @doc """
  Generates a nostrum embed for an event if the api has an error 404.
  """
  def create_api_error_embed(message) do
    import Nostrum.Struct.Embed
    import Catlixir.Helper

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
  def create_error_embed(message) do
    import Nostrum.Struct.Embed
    import Catlixir.Helper

    %Nostrum.Struct.Embed{}
    |> put_title("Oh noes! The an error meow-curred!")
    |> put_description("Something went wrong hooman!")
    |> put_image("https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/oh_noes.jpg")
    |> put_color_on_embed(message)
  end

  @doc """
  Generates a nostrum embed containing the random generated fact.
  """
  def create_fact_embed(fact_map, message) do
    import Nostrum.Struct.Embed
    import Catlixir.Helper

    fact = if String.ends_with?(fact_map["fact"], [".", "!", "?"]),
      do: fact_map["fact"], else: "#{fact_map["fact"]}."

    %Nostrum.Struct.Embed{}
    |> put_title("Random cat fact:")
    |> put_description(fact)
    |> put_image("https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/laptop.jpg")
    |> put_color_on_embed(message)
  end

end
