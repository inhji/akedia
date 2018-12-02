defmodule Akedia.Tracks.Worker do
  use GenServer

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def init(state) do
    schedule_track_fetch()
    {:ok, state}
  end

  def handle_info(:track_fetch, state) do
    last_track = last_track()
    last_listened_at = last_track["listened_at"]

    schedule_track_fetch()

    if last_listened_at !== state[:listened_at] do
      IO.inspect("New song scrobbled!")
      IO.inspect("Artist: #{last_track["track_metadata"]["artist_name"]}")
      IO.inspect("Song: #{last_track["track_metadata"]["track_name"]}")
      {:noreply, Map.put(state, :listened_at, last_listened_at)}
    else
      {:noreply, state}
    end
  end

  defp last_track do
    user = "inhji"

    data =
      "https://api.listenbrainz.org/1/user/#{user}/listens?count=1"
      |> HTTPoison.get!()
      |> Map.get(:body)
      |> Jason.decode!()

    # IO.inspect(data)

    data
    |> Map.get("payload")
    |> Map.get("listens")
    |> List.first()
  end

  defp schedule_track_fetch do
    Process.send_after(self(), :track_fetch, 5_000)
  end
end
