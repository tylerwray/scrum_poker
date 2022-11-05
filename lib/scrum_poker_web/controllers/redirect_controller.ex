defmodule ScrumPokerWeb.RedirectController do
  use ScrumPokerWeb, :controller

  import ScrumPokerWeb.UserAuth,
    only: [fetch_current_user: 2, redirect_if_user_is_authenticated: 2]

  plug :fetch_current_user
  plug :redirect_if_user_is_authenticated

  def redirect_authenticated(conn, _) do
    # Gets here only if user is authenticated
    redirect(conn, to: Routes.sign_in_path(conn, :index))
  end
end
