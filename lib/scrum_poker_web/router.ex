defmodule ScrumPokerWeb.Router do
  use ScrumPokerWeb, :router
  import ScrumPokerWeb.UserAuth, only: [redirect_if_user_is_authenticated: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ScrumPokerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ScrumPokerWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/oauth/callbacks/:provider", OAuthCallbackController, :new
  end

  scope "/", ScrumPokerWeb do
    pipe_through :browser

    get "/", RedirectController, :redirect_authenticated
    delete "/signout", OAuthCallbackController, :sign_out

    live_session :default, on_mount: [{ScrumPokerWeb.UserAuth, :current_user}] do
      live "/signin", SignInLive, :index
    end

    live_session :authenticated,
      on_mount: [{ScrumPokerWeb.UserAuth, :ensure_authenticated}] do
      live "/join-game", JoinGameLive, :index
    end
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ScrumPokerWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
