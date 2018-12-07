defmodule AkediaWeb.Helpers.Webmentions do
  require Logger
  import Phoenix.HTML, only: [raw: 1]

  def send_webmentions(url, type, action) do
    Logger.info("Sending webmentions for: #{url}")

    case Webmentions.send_webmentions(url, ".h-entry .content") do
      {:ok, list} ->
        Logger.info("Webmention sent: #{Webmentions.results_as_text(list)}")
        results = Webmentions.results_as_html(list)
        message = ["<p>", "Post #{action}! Webmentions send to these urls:", "</p>"]
        list = ["<ul>", results, "</ul>"]
        [message, list]

      {:error, reason} ->
        Logger.info("Webmention failed: #{reason}")
        ["<p>", "#{type} #{action} failed!", "</p>"]
    end
  end
end
