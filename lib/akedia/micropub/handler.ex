defmodule Akedia.Micropub.Handler do
  @behaviour PlugMicropub.HandlerBehaviour
  require Logger

  alias AkediaWeb.Router.Helpers, as: Routes
  alias Akedia.Posts

  @access_token "abcd"

  defp error_response, do: {:error, :insufficient_scope}

  @impl true
  def handle_create(type, properties, access_token) do
    # use check_access_token_debug when in dev
    with :ok <- check_access_token(access_token, "create"),
         post_attrs <- parse_properties(properties) do
      {:ok, post} = Posts.create_post(post_attrs)
      {:ok, :created, Routes.post_url(AkediaWeb.Endpoint, :show, post)}
    else
      _ -> error_response()
    end
  end

  defp parse_properties(properties) do
    post_attrs =
      %{}
      |> parse_tags(properties)
      |> parse_like(properties)
      |> parse_bookmark(properties)
      |> parse_reply(properties)
      |> parse_content(properties)
  end

  # Tags
  defp parse_tags(attrs, %{"category" => tags}),
    do: Map.put(attrs, :tags, tags)

  defp parse_tags(attrs, _), do: attrs

  # Like (like-of)
  defp parse_like(attrs, %{"like-of" => [like_of]}),
    do: Map.put(attrs, :like_of, like_of)

  defp parse_like(attrs, _), do: attrs

  # Bookmark (bookmark-of)
  defp parse_bookmark(attrs, %{"bookmark-of" => [bookmark_of]}),
    do: Map.put(attrs, :bookmark_of, bookmark_of)

  defp parse_bookmark(attrs, _), do: attrs

  # Reply (in-reply-to)
  defp parse_reply(attrs, %{"in-reply-to" => [in_reply_to]}),
    do: Map.put(attrs, :in_reply_to, in_reply_to)

  defp parse_reply(attrs, _), do: attrs

  # Content (content)
  defp parse_content(attrs, %{"content" => [content]}),
    do: Map.put(attrs, :content, content)

  defp parse_content(attrs, _), do: attrs

  defp check_access_token(access_token, required_scope \\ nil) do
    indie_config = Application.get_env(:akedia, :indie)
    token_endpoint = indie_config[:token_endpoint]
    headers = [authorization: "Bearer #{access_token}", accept: "application/json"]
    hostname = indie_config[:hostname]

    with {:ok, %HTTPoison.Response{status_code: 200} = res} <-
           HTTPoison.get(token_endpoint, headers),
         {:ok, body} = Jason.decode(res.body),
         %{"me" => ^hostname, "scope" => scope} <- body do
      check_scope(scope, required_scope)
    else
      {:ok, %HTTPoison.Response{} = res} ->
        Logger.error("Token Endpoint returned #{res.status_code}")
        error_response()

      %{"me" => me} ->
        Logger.error("Mismatch in property <me>: #{me}")
        error_response()

      %{"scope" => scope} ->
        Logger.error("Mismatch in property <scope>: #{scope}")
        error_response()

      {:error, error} ->
        Logger.error(error)
        error_response()

      {_, error} ->
        IO.inspect(error)
        Logger.error("Unknown Error")
        error_response()
    end
  end

  defp check_access_token_debug(_, _), do: :ok

  defp check_scope(_, nil), do: :ok

  defp check_scope(scope, required_scope) do
    scope = String.split(scope)

    if required_scope in scope do
      :ok
    else
      Logger.info("Required scope #{required_scope} not in scope")
      error_response()
    end
  end
end
