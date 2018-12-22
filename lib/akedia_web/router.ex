defmodule AkediaWeb.Router do
  use AkediaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug AkediaWeb.Plugs.AssignUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AkediaWeb do
    pipe_through :browser

    # Post routes
    get "/", PageController, :index
    get "/type/:type", PostController, :by_type

    # Static Pages
    get "/now", PageController, :now

    # Atom Feed
    get "/feed.xml", FeedController, :index

    resources "/posts", PostController
    resources "/tags", TagController, param: "name"
    resources "/users", UserController, except: [:delete]
    resources "/images", ImageController
    resources "/videos", VideoController

    scope "/admin" do
      get "/", AdminController, :index
    end

    scope "/auth" do
      get "/login", SessionController, :new
      post "/login", SessionController, :create
      delete "/logout", SessionController, :delete
    end
  end

  scope "/api" do
    pipe_through :api

    post "/webmention/hook",
         AkediaWeb.WebmentionController,
         :hook

    post "/micropub/media",
         AkediaWeb.MicropubController,
         :media

    forward "/micropub",
            PlugMicropub,
            handler: Akedia.Micropub.Handler,
            json_encoder: Jason
  end
end
