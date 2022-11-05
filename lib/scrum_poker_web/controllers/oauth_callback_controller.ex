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

    with {:ok, access_token} <- Github.exchange_oauth_code(code, state),
         {:ok, user} <- Accounts.register_github_user(access_token) do
      conn
      |> put_flash(:info, "Welcome #{user.email}")
      |> log_in_user(user)
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        Logger.error("failed GitHub insert #{inspect(changeset.errors)}")

        conn
        |> put_flash(
          :error,
          "We were unable to fetch the necessary information from your GithHub account"
        )
        |> redirect(to: "/")

      {:error, reason} ->
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
