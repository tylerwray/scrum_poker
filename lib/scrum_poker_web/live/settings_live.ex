defmodule ScrumPokerWeb.SettingsLive do
  use ScrumPokerWeb, :live_view
  use Phoenix.Component
  import ScrumPokerWeb.PokerComponents

  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-6xl p-12">
      <.card phx-click={JS.dispatch("card:toggle")}>5</.card>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
