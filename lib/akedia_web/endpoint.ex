defmodule AkediaWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :akedia

  socket "/socket", AkediaWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :akedia,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  plug Plug.Static,
    at: "/uploads",
    from: Path.expand("./uploads"),
    gzip: false

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_akedia_key",
    signing_salt: "bad20a0867e9402a8ff028b5c6dd2139",
    encryption_salt: "a21b66180a55470f8c85a0313536bf04",
    max_age: 604_800,
    http_only: true

  plug AkediaWeb.Router
end
