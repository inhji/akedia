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

    get "/", PageController, :index
    get "/feed", FeedController, :index

    resources "/posts", PostController
    resources "/users", UserController, only: [:create, :new, :show, :edit, :update]

    scope "/admin" do
      get "/", AdminController, :index
    end

    scope "/auth" do
      get "/login", SessionController, :new
      post "/login", SessionController, :create
      delete "/logout", SessionController, :delete
    end
  end

  scope "/api", AkediaWeb do
    pipe_through :api

    post "/webmention/hook", WebmentionController, :hook
  end

  # scope "/webmention", AkediaWeb do
  #   pipe_through :api
  #
  #   post "/hook", MentionController, :hook
  # end
end
