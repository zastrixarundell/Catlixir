defmodule Catlixir.Command.Fact do
  @behaviour Catlixir.Command
  alias Nostrum.Api

  @doc false
  def perform(_arguments, message) do
    case base_fact_url() |> HTTPoison.get() do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        embed =
          body
          |> Jason.decode!()
          |> create_fact_embed

        message.channel_id
        |> Api.create_message(embed: embed)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        message.channel_id
        |> Api.create_message(embed: create_api_error_embed())

      {:error, _error} ->
        message.channel_id
        |> Api.create_message(embed: create_error_embed())

    end
    :ok
  end

  @spec base_fact_url :: String.t()
  def base_fact_url do
    "https://catfact.ninja/fact"
  end

  def create_api_error_embed do
    import Nostrum.Struct.Embed

    %Nostrum.Struct.Embed{}
    |> put_title("Oh noes! The page wasn't found!")
    |> put_description("The page from where I get the facts is down! This is a cat-astrophe!")
    |> put_image("https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/oh_noes.jpg")
  end

  def create_error_embed do
    import Nostrum.Struct.Embed

    %Nostrum.Struct.Embed{}
    |> put_title("Oh noes! The an error meow-curred!")
    |> put_description("Something went wrong hooman!")
    |> put_image("https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/oh_noes.jpg")
  end

  def create_fact_embed(fact_map) do
    import Nostrum.Struct.Embed

    %Nostrum.Struct.Embed{}
    |> put_title("Random cat fact:")
    |> put_description(fact_map["fact"])
    |> put_image("https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/interesting.jpg")
  end

end
