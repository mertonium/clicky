defmodule ClickyWeb.Router do
  use ClickyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ClickyWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/login", PageController, :login
    get "/arena", PageController, :arena
  end

  # Other scopes may use custom stacks.
  # scope "/api", ClickyWeb do
  #   pipe_through :api
  # end
end
