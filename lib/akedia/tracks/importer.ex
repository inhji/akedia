defmodule Akedia.Tracks.Importer do
  require Logger
  alias Akedia.Tracks

  def fetch(user, count, last_listen) do
    Logger.info("Fetching last #{count} tracks")
    Logger.info("> User: #{user}")
    Logger.info("> Since: #{convert_timestamp(last_listen)}")

    url = api_url(user, count, last_listen)
    tracks = get_tracks(url)

    new_track_count =
      get_new_tracks(tracks, last_listen)
      |> insert_tracks()
      |> Enum.count()

    new_last_listen =
      tracks
      |> List.first()
      |> Access.get("listened_at")

    if new_track_count > 0 do
      Logger.info("Imported #{new_track_count} new Tracks!")
    end

    {:ok, new_last_listen}
  end

  def get_tracks(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode!(body)
        |> Map.get("payload")
        |> Map.get("listens")

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        Logger.warn("Error while fetching tracks: #{inspect(status_code)}")
        []

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.warn("Error while fetching tracks: #{inspect(reason)}")
        []
    end
  end

  def convert_timestamp(timestamp) do
    (timestamp * 1000)
    |> DateTime.from_unix!(:millisecond)
  end

  def get_new_tracks(tracks, last_listen) do
    tracks
    |> Enum.filter(fn track ->
      track["listened_at"] > last_listen
    end)
  end

  defp insert_tracks(new_tracks) do
    new_tracks
    |> Enum.map(&format_track/1)
    |> Enum.map(&Tracks.create_track/1)
    |> Enum.filter(fn {atom, _result} ->
      case atom do
        :ok -> true
        _ -> false
      end
    end)
  end

  def api_url(user, count, min_ts) do
    URI.to_string(%URI{
      scheme: "https",
      host: "api.listenbrainz.org",
      path: "/1/user/#{user}/listens",
      query: "count=#{count}&min_ts=#{min_ts}"
    })
  end

  def format_track(track) do
    %{
      :listened_at => convert_timestamp(track["listened_at"]),
      :timestamp => track["listened_at"],
      :name => track["track_metadata"]["track_name"],
      :artist => track["track_metadata"]["artist_name"],
      :album => track["track_metadata"]["release_name"]
    }
  end
end
