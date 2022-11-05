defmodule ScrumPokerWeb.OAuthCallbackController do
  use ScrumPokerWeb, :controller
  require Logger

  import ScrumPokerWeb.UserAuth, only: [log_in_user: 2, log_out_user: 1]

  alias ScrumPoker.Accounts
  alias ScrumPoker.Github

  def new(conn, %{"provider" => "github", "error" => "access_denied"}) do
    redirect(conn, to: "/")
  end

  def new(conn, params) do
    %{"provider" => "github", "code" => code, "state" => state} = params

    with {:ok, github_token} <- Github.exchange_oauth_code(code, state),
         {:ok, user} <- Github.get_user(github_token),
         {:ok, email} <- Github.get_user_primary_email(github_token),
         attrs = Map.merge(user, %{github_token: github_token, email: email}),
         {:ok, user} <- Accounts.register_github_user(attrs) do
      conn
      |> put_flash(:info, "Welcome #{user.email}")
      |> log_in_user(user)
    else
      reason ->
        Logger.error("failed GitHub exchange #{inspect(reason)}")

        conn
        |> put_flash(:error, "We were unable to contact GitHub. Please try again later")
        |> redirect(to: "/")
    end
  end

  def sign_out(conn, _) do
    log_out_user(conn)
  end
end
