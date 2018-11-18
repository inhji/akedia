defmodule AkediaWeb.Helpers.Webmentions do
  def send_webmentions(url, type, action) do
    urls =
      case Webmentions.send_webmentions(url) do
        {:ok, list} ->
          list

        {:error, reason} ->
          [reason]
      end

    "#{type} #{action} successfully. Webmentions sent to these endpoints:\n" <>
      Webmentions.results_as_text(urls)
  end
end
