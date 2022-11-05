defmodule ScrumPokerWeb.JoinGameLive do
  use ScrumPokerWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      You're logged in!
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
