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

    result =
      breed
      |> create_url()
      |> HTTPoison.get("x-api-key": @cat_api)

    case result do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        results = Jason.decode!(body)

        if Enum.empty?(results) do
          Api.create_message(message.channel_id, embed: create_empty_embed(message))
        else
          cat_breed(breed, results)
          |> results_to_embeds(message)
          |> Enum.map(fn embed ->
            Api.create_message(message.channel_id, embed: embed)
          end)
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        message.channel_id
        |> Api.create_message(embed: create_api_error_embed!(message))

      {:error, _error} ->
        message.channel_id
        |> Api.create_message(embed: create_error_embed!(message))
    end

    :ok
  end

  def cat_breed("", results) do
    Enum.random(results) |> List.wrap()
  end

  def cat_breed(_, results) do
    results |> Enum.take(5)
  end

  def create_url("") do
    "https://api.thecatapi.com/v1/breeds"
  end

  @doc """
  Creates a url to search about the specified breed.
  Encodes and creates the needed parameter.
  """
  def create_url(breed) do
    breed = URI.encode_www_form(breed)

    "https://api.thecatapi.com/v1/breeds/search?q=#{breed}"
  end

  @doc """
  Transforms the results into embeds and andds colors.

  The inputs are an array of Map elements from the API and
  the message in which this was created.
  """
  def results_to_embeds(results, message) do
    for result <- results do
      import Nostrum.Struct.Embed

      {name, result} = Map.pop(result, "name")
      {description, result} = Map.pop(result, "description")
      {wiki, result} = Map.pop(result, "wikipedia_url")

      embed =
        Catlixir.Helper.create_empty_embed!(message)
        |> put_title("#{name}")
        |> put_description(description)
        |> put_url(wiki)
        |> put_image(get_wiki_image_url!(wiki))

      permit = ["health_issues", "alt_names", "life_span"]

      result =
        Enum.reduce(result, embed, fn {key, value}, buffer ->
          if !is_map(value) and !is_nil(value) and !String.equivalent?("#{value}", "") and
               Enum.member?(permit, key) do
            key =
              key
              |> String.capitalize()
              |> String.replace("_", " ")

            put_field(buffer, "#{key}", value, true)
          else
            buffer
          end
        end)

      result |> put_color_on_embed(message)
    end
  end

  @doc """
  Creates and embed struct for when a breed could not be found.
  """
  def create_empty_embed(message) do
    import Nostrum.Struct.Embed

    Catlixir.Helper.create_empty_embed!(message)
    |> put_title("Oh noes! An error meow-curred!")
    |> put_description("I couldn't find that breed!")
    |> put_image(
      "https://raw.githubusercontent.com/zastrixarundell/Catlixir/master/assets/oh_noes.jpg"
    )
  end

  @doc false
  def get_wiki_image_url!(wiki) when is_nil(wiki) do
    nil
  end

  @doc """
  Gets an of the wiki url (if there is one). It will
  return nil if nothing is found.
  """
  def get_wiki_image_url!(wiki) do
    name =
      wiki
      |> String.replace_prefix("https://en.wikipedia.org/wiki/", "")
      |> String.replace("(cat)", "cat")

    result =
      "https://en.wikipedia.org/w/api.php?action=query&prop=pageimages&format=json&piprop=original&titles=#{
        name
      }"
      |> HTTPoison.get()

    case result do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        pages =
          body
          |> Jason.decode!()
          |> Map.get("query")
          |> Map.get("pages")

        if(Enum.member?(pages, -1)) do
          nil
        else
          {_id, data} =
            pages
            |> Map.to_list()
            |> List.first()

          data["original"]["source"]
        end

      _ ->
        nil
    end
  end
end
