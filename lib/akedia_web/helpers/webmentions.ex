defmodule AkediaWeb.Helpers.Webmentions do
  require Logger

  def send_webmentions(url, type, action) do
    Logger.info("Sending webmentions for: #{url}")

    case Webmentions.send_webmentions(url) do
      {:ok, list} ->
        Logger.info("Webmention sent: #{Webmentions.results_as_text(list)}")

        "#{type} #{action} successfully. Webmentions sent to these endpoints:\n" <>
          Webmentions.results_as_text(list)

      {:error, reason} ->
        Logger.info("Webmention failed: #{reason}")
        "#{type} #{action} failed!"
    end
  end
end
