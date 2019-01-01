defmodule AkediaWeb.Router do
  use AkediaWeb, :router

  alias AkediaWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Plugs.AssignUser
    plug Plugs.MenuItems, ["social"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AkediaWeb do
    pipe_through :browser

    # Post routes
    get "/", PageController, :index

    # Static Pages
    get "/now", PageController, :now

    # Atom Feed
    get "/feed.xml", FeedController, :index

    get "/posts/of-type/:type", PostController, :by_type
    resources "/posts", PostController

    resources "/tags", TagController, param: "name"
    resources "/users", UserController, except: [:delete, :create, :new]
    resources "/photos", ImageController
    resources "/videos", VideoController

    resources "/menus", MenuController do
      resources "/links", LinkController, except: [:index]
    end

    scope "/admin" do
      get "/", AdminController, :index
    end

    scope "/auth" do
      get "/register", UserController, :new
      post "/register", UserController, :create
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
