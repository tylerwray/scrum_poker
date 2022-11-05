defmodule ScrumPokerWeb.JoinGameLive do
  use ScrumPokerWeb, :live_view
  use Phoenix.Component

  alias ScrumPokerWeb.Router.Helpers, as: Routes

  def render(assigns) do
    ~H"""
    <div>
      You're logged in!
      <.dropdown id="user-dropdown">
        <:img src={@current_user.avatar_url} />
        <:title><%= @current_user.display_name %></:title>
        <:subtitle>@<%= @current_user.email %></:subtitle>
        <%!-- <:link navigate={profile_path(@current_user)}>View Profile</:link> --%>
        <%!-- <:link navigate={Routes.settings_path(Endpoint, :edit)}>Settings</:link> --%>
        <:link href={Routes.o_auth_callback_path(ScrumPokerWeb.Endpoint, :sign_out)} method={:delete}>
          Sign out
        </:link>
      </.dropdown>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
