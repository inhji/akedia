defmodule AkediaWeb.WebmentionController do
  use AkediaWeb, :controller

  alias Akedia.Mentions

  defp secret, do: "46042c23-6ce4-4d3e-bfdc-297877a16066"

  defp get_host(url) do
    URI.parse(url).host
  end

  defp secret_matches?(secret) do
    secret == secret()
  end

  defp host_matches?(conn, url) do
    get_host(Routes.page_url(conn, :index)) == get_host(url)
  end

  defp is_valid_mention?(conn, params) do
    if !secret_matches?(params["secret"]) do
      {:error, "Secret does not match!"}
    else
      if !host_matches?(conn, params["target"]) do
        {:error, "Target does not match!"}
      else
        if params["post"]["type"] != "entry" do
          {:error, "Only type entry is allowed!"}
        else
          case captures = Regex.run(~r/\/posts\/(\d+)/, params["target"]) do
            nil ->
              {:error, "Target url is malformed!"}

            _ ->
              post_id = List.last(captures)
              {:ok, String.to_integer(post_id)}
          end
        end
      end
    end
  end

  def hook(conn, %{"post" => post} = params) do
    case is_valid_mention?(conn, params) do
      {:error, message} ->
        conn |> text(message)

      {:ok, post_id} ->
        author = post["author"]
        mention_type = post["wm-property"]
        mention_value = post[mention_type]

        Mentions.create_mention(%{
          mention_type: mention_type,
          mention_value: mention_value,
          source_url: params["source"],
          target_url: params["target"],
          author: author["name"],
          author_avatar: author["photo"],
          author_url: author["url"],
          title: post["name"],
          post_id: post_id
        })

        conn |> text("YAY!")
    end
  end
end
