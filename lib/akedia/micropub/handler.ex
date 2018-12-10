defmodule Akedia.Micropub.Handler do
  @behaviour PlugMicropub.HandlerBehaviour
  require Logger

  alias AkediaWeb.Router.Helpers, as: Routes
  alias Akedia.Posts
  alias Akedia.Micropub.Properties

  @post_id ~r/\/posts\/(?<id>\d+)$/

  @supported_scopes ["create", "update"]

  defp error_response, do: {:error, :insufficient_scope}

  @impl true
  def handle_create(_type, properties, access_token) do
    # use check_access_token_debug when in dev
    with :ok <- check_access_token(access_token, "create"),
         post_attrs <- Properties.parse(properties) do
      {:ok, post} = Posts.create_post(post_attrs)
      post_url = Routes.post_url(AkediaWeb.Endpoint, :show, post)
      {:ok, :created, post_url}
    else
      _ -> error_response()
    end
  end

  @impl true
  def handle_update(url, replace, add, delete, access_token) do
    with :ok <- check_access_token(access_token, "update"),
         post_attrs <- Properties.parse(replace, add, delete),
         post_id <- get_post_id(url) do
      post = Posts.get_post!(post_id)

      case Posts.update_post(post, post_attrs) do
        {:ok, post} ->
          post_url = Routes.post_url(AkediaWeb.Endpoint, :show, post)
          {:ok, :created, post_url}

        _ ->
          error_response()
      end
    else
      _ -> error_response()
    end
  end

  def check_access_token(access_token, required_scope \\ nil) do
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
      {atom, error} ->
        Logger.error("#{inspect(atom)} - #{inspect(error)}")
        Logger.error("Unknown Error")
        error_response()
    end
  end

  def check_access_token_debug(_, _), do: :ok

  def check_scope(_, nil), do: :ok

  def check_scope(scope, required_scope) do
    if !Enum.member?(@supported_scopes, required_scope) do
      error_response()
    else
      scope = String.split(scope)

      if Enum.member?(scope, required_scope) do
        :ok
      else
        error_response()
      end
    end
  end

  def get_post_id(url) do
    with %{"id" => id} = Regex.named_captures(@post_id, url),
         {result, _} = Integer.parse(id) do
      result
    end
  end
end
