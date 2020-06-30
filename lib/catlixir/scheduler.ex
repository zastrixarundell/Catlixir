defmodule Catlixir.Scheduler do
  use Quantum, otp_app: :catlixir

  alias DiscordBotList.Struct.BotStats

  @doc false
  def update_dbl_status() do
    number_of_shards = Application.get_env(:nostrum, :num_shards)
    server_count = Catlixir.get_server_count!()

    stats = %BotStats{
      shard_count: number_of_shards,
      server_count: server_count
    }

    BotStats.post_updated_data(stats: stats)
  end

end
