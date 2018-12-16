defmodule Akedia.Tracks.Worker do
  use GenServer
  alias Akedia.Tracks

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

  def start_link(args \\ %{}) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(state) do
    schedule_track_fetch(5_000)
    {:ok, state}
  end

  def last_listen(tracks) do
    tracks
    |> List.first()
    |> Access.get("listened_at")
  end

  def get_new_tracks(tracks, last_listen) do
    tracks
    |> Enum.filter(fn t -> t["listened_at"] > last_listen end)
  end

  def format_tracks(tracks) do
    tracks
    |> Enum.map(fn t ->
      %{
        :listened_at => convert_timestamp(t["listened_at"]),
        :timestamp => t["listened_at"],
        :name => t["track_metadata"]["track_name"],
        :artist => t["track_metadata"]["artist_name"],
        :album => t["track_metadata"]["release_name"]
      }
    end)
  end

  def convert_timestamp(timestamp) do
    (timestamp * 1000)
    |> DateTime.from_unix!(:millisecond)
  end

  def handle_info(:track_fetch, state) do
    count = 5
    tracks = get_tracks(count)
    new_tracks = get_new_tracks(tracks, state[:last_listen])

    new_tracks
    |> format_tracks()
    |> Enum.each(&Tracks.create_track/1)

    schedule_track_fetch(state[:interval])

    case Enum.count(new_tracks) do
      0 ->
        new_state =
          state
          |> Map.put(:last_call, :empty)

        {:noreply, new_state}

      new_track_count ->
        IO.puts("Imported #{new_track_count} new Tracks!")

        new_state =
          state
          |> Map.put(:last_listen, last_listen(tracks))
          |> Map.put(:last_call, :new_tracks)

        {:noreply, new_state}
    end
  end

  def handle_info(info, _state) do
    IO.inspect(info)
  end

  defp get_tracks(count) do
    user = "inhji"

    IO.puts("Getting last #{count} tracks for user #{user}")

    data =
      "https://api.listenbrainz.org/1/user/#{user}/listens?count=#{count}"
      |> HTTPoison.get!()
      |> Map.get(:body)
      |> Jason.decode!()

    data
    |> Map.get("payload")
    |> Map.get("listens")
  end

  defp schedule_track_fetch(milliseconds) do
    Process.send_after(self(), :track_fetch, milliseconds)
  end
end
