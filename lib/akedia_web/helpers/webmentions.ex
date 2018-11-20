defmodule AkediaWeb.Helpers.Webmentions do
  def send_webmentions(url, type, action) do
    case Webmentions.send_webmentions(url) do
      {:ok, list} ->
        "#{type} #{action} successfully. Webmentions sent to these endpoints:\n" <>
          Webmentions.results_as_text(list)

      {:error, reason} ->
        IO.inspect(reason)
        "#{type} #{action} failed!"
    end
  end
end
