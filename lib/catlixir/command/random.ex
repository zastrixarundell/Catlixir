defmodule Catlixir.Command.Random do
  @behaviour Catlixir.Command
  @moduledoc """
  Module representing the random discord command
  """

  @doc false
  def perform(_arguments, message) do
    alias Nostrum.Api

    Api.create_message(message.channel_id, embed: create_random_pic_embed(message))
    :ok
  end

  import Catlixir.Helper
  import Nostrum.Struct.Embed

  @doc """
  Sends a random image from the CATAAS API.
  """
  def create_random_pic_embed(message) do

    %Nostrum.Struct.Embed{}
    |> put_title("Random cat image!")
    |> put_image("https://cataas.com/cat?#{generate_random_unique_param()}")
    |> put_color_on_embed(message)
  end

  @doc """
  Generates a random unique param which is the system time.
  Discord would usually cache the image on the URL and this way
  you will 100% have a non-cached unique image.
  """
  def generate_random_unique_param do
    "unique=#{:os.system_time(:millisecond)}"
  end
end
