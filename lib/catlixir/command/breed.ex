defmodule Catlixir.Command.Breed do
  @moduledoc """
  Module regarding the breed discord command.
  """

  @behaviour Catlixir.Command

  @cat_api Application.get_env(:catlixir, :the_cat_api_key)

  import Catlixir.Helper
  import Nostrum.Struct.Embed

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
          |> Enum.each(&Api.create_message(message.channel_id, embed: &1))
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

  @doc """
  Extract information about the cat breed. When `breed` is set
  to `""` then it takes a random result. Otherwise it responds
  with the first 5 results for a search query.
  """
  @spec cat_breed(breed :: String.t(), list()) :: list()
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
      {name, result} = Map.pop(result, "name")
      {description, result} = Map.pop(result, "description")
      {wiki, result} = Map.pop(result, "wikipedia_url")

      Catlixir.Helper.create_empty_embed!(message)
      |> put_title(name)
      |> put_description(description)
      |> put_url(wiki)
      |> put_image(get_wiki_image_url!(wiki))
      |> (&Enum.reduce(result, &1, fn kv, buff -> enrich_embed(kv, buff) end)).()
      |> put_color_on_embed(message)
    end
  end

  @permitable_fields ["health_issues", "alt_names", "life_span"]

  @doc """
  Enriches the embed with the fields from `key`/`value`. Only is enriched when
  `key` is in @permitable_fields and value is not nil.
  """
  @spec enrich_embed({key :: String.t(), value :: any()}, embed :: Nostrum.Struct.Embed.t()) ::
          Nostrum.Struct.Embed.t()
  def enrich_embed({_, ""}, embed) do
    embed
  end

  def enrich_embed({key, value}, embed) when key in @permitable_fields and not is_nil(value) do
    key =
      key
      |> String.capitalize()
      |> String.replace("_", " ")

    put_field(embed, key, value, true)
  end

  def enrich_embed(_, embed) do
    embed
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

        unless Enum.member?(pages, -1) do
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
