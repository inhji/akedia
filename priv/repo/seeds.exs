# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Akedia.Repo.insert!(%Akedia.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

seed_file = "./data.json"

if File.exists?(seed_file) do
  contents = File.read!(seed_file)
  list = Jason.decode!(contents)

  list
  |> Enum.map(fn item ->
    %{
      :artist => item["artist_name"],
      :timestamp => item["timestamp"],
      :album => item["release_name"],
      :name => item["track_name"],
      :listened_at =>
        (item["timestamp"] * 1000)
        |> DateTime.from_unix!(:millisecond)
    }
  end)
  |> Enum.each(&Akedia.Tracks.create_track/1)
end
