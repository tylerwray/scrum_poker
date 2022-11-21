defmodule ScrumPokerWeb.GameLive do
  use ScrumPokerWeb, :live_view

  import ScrumPokerWeb.PokerComponents
  import ScrumPokerWeb.Layout
  alias ScrumPoker.Poker
  alias ScrumPokerWeb.Presence

  def render(assigns) do
    ~H"""
    <%= if is_nil(@current_user) do %>
      <.anonymous_nav />
    <% end %>
    <div class="mx-auto max-w-6xl px-12">
      <h2 class="text-lg font-light text-center">
        Game Code
      </h2>
      <h1 class="text-4xl font-bold text-center pb-4">
        <%= @game.join_code %>
      </h1>
      <p class="text-center max-w-xl pb-8 mx-auto">
        <%= @game.description %>
      </p>
      <div class="grid grid-cols-4 gap-14 justify-items-center">
        <%= for card <- @game.deck do %>
          <.card
            is_flipped
            is_selected={@selected_card == card}
            color={@deck_color}
            phx-click="select_card"
            phx-value-card={card}
          >
            <%= card %>
          </.card>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(%{"join_code" => join_code}, _session, socket) do
    if connected?(socket) do
      ScrumPokerWeb.Endpoint.subscribe(topic(join_code))

      Presence.track(self(), topic(join_code), user_uuid(socket.assigns), %{
        online_at: inspect(System.system_time(:second)),
        display_name: user_display_name(socket.assigns),
        deck_color: user_deck_color(socket.assigns)
      })
    end

    socket =
      socket
      |> assign(:current_user, socket.assigns.current_user)
      |> assign(:deck_color, user_deck_color(socket.assigns))
      |> assign(:selected_card, nil)
      |> assign_game(join_code)

    {:ok, socket}
  end

  defp assign_game(socket, join_code) do
    case Poker.get_game_by(join_code: join_code) do
      nil ->
        socket
        |> push_navigate(to: "/")
        |> put_flash(:error, "Game #{join_code} does not exist.")

      game ->
        assign(socket, :game, game)
    end
  end

  def handle_event("select_card", %{"card" => card}, socket) do
    ScrumPokerWeb.Endpoint.broadcast(
      topic(socket.assigns.game.join_code),
      "card.selected",
      %{"user_uuid" => user_uuid(socket.assigns), "card" => card}
    )

    {:noreply, assign(socket, :selected_card, card)}
  end

  def handle_info(%{event: "selections.reset"}, socket) do
    {:noreply, assign(socket, :selected_card, nil)}
  end

  def handle_info(_broadcast, socket) do
    {:noreply, socket}
  end

  defp topic(join_code) do
    "game:#{join_code}"
  end

  defp user_uuid(%{current_user: %{uuid: uuid}}) do
    uuid
  end

  defp user_uuid(%{anonymous_user: %{uuid: uuid}}) do
    uuid
  end

  defp user_display_name(%{current_user: %{display_name: display_name}}) do
    display_name
  end

  defp user_display_name(%{anonymous_user: %{display_name: display_name}}) do
    display_name
  end

  defp user_deck_color(%{current_user: %{deck_color: deck_color}}) do
    deck_color
  end

  defp user_deck_color(%{anonymous_user: %{deck_color: deck_color}}) do
    deck_color
  end
end
