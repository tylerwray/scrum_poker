defmodule ScrumPokerWeb.RedirectController do
  use ScrumPokerWeb, :controller

  def redirect_authenticated(conn, _) do
    # Gets here only if user is authenticated
    redirect(conn, to: Routes.sign_in_path(conn, :index))
  end
end
