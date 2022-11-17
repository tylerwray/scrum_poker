defmodule ScrumPokerWeb.UserAuth do
  @moduledoc """
  A service module to handle web user authentication.
  """
  import Plug.Conn
  import Phoenix.Controller

  alias Phoenix.LiveView
  alias Phoenix.Component
  alias ScrumPoker.Accounts
  alias ScrumPokerWeb.Router.Helpers, as: Routes

  def on_mount(:current_user, _params, session, socket) do
    case session do
      %{"user_id" => user_id} ->
        {:cont, Component.assign_new(socket, :current_user, fn -> Accounts.get_user(user_id) end)}

      %{"anonymous_user" => anonymous_user} ->
        {:cont,
         socket
         |> Component.assign_new(:anonymous_user, fn -> anonymous_user end)
         |> Component.assign(:current_user, nil)}

      %{} ->
        {:cont, Component.assign(socket, :current_user, nil)}
    end
  end

  def on_mount(:ensure_authenticated, _params, session, socket) do
    case session do
      %{"user_id" => user_id} ->
        new_socket =
          Component.assign_new(socket, :current_user, fn -> Accounts.get_user!(user_id) end)

        %Accounts.User{} = new_socket.assigns.current_user
        {:cont, new_socket}

      %{} ->
        {:halt, redirect_require_login(socket)}
    end
  rescue
    Ecto.NoResultsError -> {:halt, redirect_require_login(socket)}
  end

  defp redirect_require_login(socket) do
    socket
    |> LiveView.put_flash(:error, "Please sign in")
    |> LiveView.redirect(to: Routes.sign_in_path(socket, :index))
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:current_user] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Authenticates the user by looking into the session.
  """
  def fetch_current_user(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Accounts.get_user(user_id)
    assign(conn, :current_user, user)
  end

  def signed_in_path(conn) do
    Routes.home_path(conn, :index)
  end

  @doc """
  Logs the user in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_user(conn, user) do
    user_return_to = get_session(conn, :user_return_to)
    conn = assign(conn, :current_user, user)

    conn
    |> renew_session()
    |> put_session(:user_id, user.id)
    |> put_session(:live_socket_id, "users_sessions:#{user.id}")
    |> redirect(to: user_return_to || signed_in_path(conn))
  end

  def put_anonymous_user(conn, _opts) do
    if get_session(conn, "anonymous_user") do
      conn
    else
      put_session(conn, :anonymous_user, Accounts.create_anonymous_user())
    end
  end

  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_user(conn) do
    # if live_socket_id = get_session(conn, :live_socket_id) do
    # ScrumPokerWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    # end

    conn
    |> renew_session()
    |> redirect(to: Routes.sign_in_path(conn, :index))
  end
end
