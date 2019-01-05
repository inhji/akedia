defmodule Akedia.Tracks.Worker do
  use GenServer
  alias Akedia.Tracks
  alias Akedia.Tracks.Importer
  require Logger

  # Sample Track Response
  # %{
  #   "listened_at" => 1544950499,
  #   "recording_msid" => "4565c6b9-82e9-4cc8-8100-033ca58964d0",
  #   "track_metadata" => %{
  #     "additional_info" => %{
  #       "artist_mbids" => [],
  #       "artist_msid" => "e86b0281-9188-48e4-a27f-5509a277e6c1",
  #       "isrc" => nil,
  #       "recording_mbid" => nil,
  #       "recording_msid" => "4565c6b9-82e9-4cc8-8100-033ca58964d0",
  #       "release_group_mbid" => nil,
  #       "release_mbid" => nil,
  #       "release_msid" => "036a1bc0-4922-4209-a4f4-d54e38582478",
  #       "spotify_id" => nil,
  #       "tags" => [],
  #       "track_mbid" => nil,
  #       "tracknumber" => nil,
  #       "work_mbids" => []
  #     },
  #     "artist_name" => "aivi & surasshu",
  #     "release_name" => "The Black Box",
  #     "track_name" => "Lonely Rolling Star (Missing You)"
  #   }
  # }
  # Last 5 Tracks:
  # =================================
  # [
  #   %{listened_at: 1544952089, name: "Pocket Universe"},
  #   %{listened_at: 1544951734, name: "Distance (Bicycle Trip)"},
  #   %{listened_at: 1544951676, name: "38"},
  #   %{listened_at: 1544951419, name: "Mika"},
  #   %{listened_at: 1544951065, name: "Here's How!"}
  # ]
  # Last 5 Tracks (New Track Exosphere):
  # =================================
  # [
  #   %{listened_at: 1544952375, name: "Exosphere"},
  #   %{listened_at: 1544952089, name: "Pocket Universe"},
  #   %{listened_at: 1544951734, name: "Distance (Bicycle Trip)"},
  #   %{listened_at: 1544951676, name: "38"},
  #   %{listened_at: 1544951419, name: "Mika"}
  # ]

  def start_link(_args) do
    config = Application.get_env(:akedia, Akedia.Tracks.Worker)

    fetch_enabled = config[:enabled]
    fetch_user = config[:user]
    fetch_count = config[:count] || 5
    interval_ms = config[:interval] || 600_000
    last_listen = config[:last_listen] || 0
    last_call = config[:last_call] || :empty

    initial_state = %{
      fetch_enabled: fetch_enabled,
      fetch_count: fetch_count,
      fetch_user: fetch_user,
      interval: interval_ms,
      last_listen: last_listen,
      last_call: last_call
    }

    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def init(state) do
    if state[:fetch_enabled] do
      schedule_track_fetch(5_000)
    end

    {:ok, state}
  end

  def handle_info(:track_fetch, state) do
    count = state[:fetch_count]
    user = state[:fetch_user]
    last_listen = state[:last_listen]

    {:ok, new_last_listen} = Importer.fetch(user, count, last_listen)

    {:noreply,
     state
     |> Map.put(:last_listen, new_last_listen)
     |> Map.put(:last_call, :new_tracks)}
  end

  def handle_info(info, state) do
    Logger.debug("handle_info: #{inspect(info)}")
    {:noreply, state}
  end

  defp schedule_track_fetch(milliseconds) do
    Process.send_after(self(), :track_fetch, milliseconds)
  end
end
