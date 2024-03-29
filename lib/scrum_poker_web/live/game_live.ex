defmodule ScrumPokerWeb.GameLive do
  use ScrumPokerWeb, :live_view

  import ScrumPokerWeb.PokerComponents
  import ScrumPokerWeb.Layout
  alias ScrumPoker.Poker
  alias ScrumPokerWeb.Presence

  def render(assigns) do
    ~H"""
    <%= if is_nil(@current_user) do %>
      <.anonymous_nav display_name={@display_name} />
    <% end %>
    <div class="grid gap-4 mx-auto max-w-6xl px-12">
      <div class="px-16">
        <.game_description game={@game} />
      </div>
      <div class="grid grid-cols-3 sm:grid-cols-4 gap-14 justify-items-center">
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

      Presence.track(self(), topic(join_code), user_attribute(socket, :uuid), %{
        online_at: inspect(System.system_time(:second)),
        display_name: user_attribute(socket, :display_name),
        deck_color: user_attribute(socket, :deck_color)
      })
    end

    socket =
      socket
      |> assign(:current_user, socket.assigns.current_user)
      |> assign(:deck_color, user_attribute(socket, :deck_color))
      |> assign(:display_name, user_attribute(socket, :display_name))
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
      %{"user_uuid" => user_attribute(socket, :uuid), "card" => card}
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

  defp user_attribute(socket, attribute) do
    case socket.assigns do
      %{current_user: %{^attribute => value}} -> value
      %{anonymous_user: %{^attribute => value}} -> value
      _ -> nil
    end
  end
end
