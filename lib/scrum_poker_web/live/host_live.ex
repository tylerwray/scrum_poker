defmodule ScrumPokerWeb.HostLive do
  use ScrumPokerWeb, :live_view

  import ScrumPokerWeb.PokerComponents

  alias ScrumPoker.Poker
  alias ScrumPokerWeb.Presence

  def render(assigns) do
    ~H"""
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
      <div class="text-center pb-8">
        <.button phx-click="toggle_cards" variant="outline">Toggle Results</.button>
        <.button phx-click="reset_selections" variant="ghost">Reset</.button>
      </div>
      <div class="grid grid-cols-3 sm:grid-cols-4 gap-14 justify-items-center">
        <%= for {user_uuid, %{display_name: display_name, deck_color: deck_color}} <- @users do %>
          <div class="grid justify-items-center gap-1">
            <%= if @selections[user_uuid] do %>
              <.card is_flipped={@is_cards_shown} color={deck_color}><%= @selections[user_uuid] %></.card>
            <% else %>
              <.waiting />
            <% end %>
            <div class="text-ellipsis overflow-hidden whitespace-nowrap w-max"><%= display_name %></div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(%{"join_code" => join_code}, _session, socket) do
    if connected?(socket) do
      ScrumPokerWeb.Endpoint.subscribe(topic(join_code))
    end

    socket =
      socket
      |> assign_game(join_code)
      |> assign(:users, %{})
      |> assign(:selections, %{})
      |> assign(:is_cards_shown, false)
      |> handle_joins(Presence.list(topic(join_code)))

    {:ok, socket}
  end

  defp assign_game(socket, join_code) do
    case Poker.get_game_by(join_code: join_code) do
      nil ->
        socket
        |> push_navigate(to: "/home")
        |> put_flash(:error, "Game #{join_code} does not exist.")

      game ->
        assign(socket, :game, game)
    end
  end

  def handle_event("toggle_cards", _params, socket) do
    {:noreply, assign(socket, :is_cards_shown, !socket.assigns.is_cards_shown)}
  end

  def handle_event("reset_selections", _params, socket) do
    ScrumPokerWeb.Endpoint.broadcast(
      topic(socket.assigns.game.join_code),
      "selections.reset",
      %{}
    )

    socket =
      socket
      |> assign(:selections, %{})

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", payload: diff}, socket) do
    socket =
      socket
      |> handle_leaves(diff.leaves)
      |> handle_joins(diff.joins)

    {:noreply, socket}
  end

  def handle_info(
        %{event: "card.selected", payload: %{"user_uuid" => user_uuid, "card" => card}},
        socket
      ) do
    {:noreply, assign(socket, :selections, Map.put(socket.assigns.selections, user_uuid, card))}
  end

  defp handle_joins(socket, joins) do
    Enum.reduce(joins, socket, fn {user_uuid, %{metas: [meta | _]}}, socket ->
      assign(socket, :users, Map.put(socket.assigns.users, user_uuid, meta))
    end)
  end

  defp handle_leaves(socket, leaves) do
    Enum.reduce(leaves, socket, fn {user_uuid, _}, socket ->
      assign(socket, :users, Map.delete(socket.assigns.users, user_uuid))
    end)
  end

  defp topic(join_code) do
    "game:#{join_code}"
  end

  defp waiting(assigns) do
    ~H"""
    <div class="grid grid-cols-3 items-center px-2 w-24 h-36 bg-gray-300/50 dark:bg-gray-800/50 rounded-md">
      <div class="animate-waiting mx-auto">
        <.dot class="stroke-[4px] text-white text-2xl" />
      </div>
      <div class="animate-waiting mx-auto animation-delay-1">
        <.dot class="stroke-[4px] text-white text-2xl" />
      </div>
      <div class="animate-waiting mx-auto animation-delay-2">
        <.dot class="stroke-[4px] text-white text-2xl" />
      </div>
    </div>
    """
  end

  attr :rest, :global

  defp dot(assigns) do
    ~H"""
    <svg
      stroke="currentColor"
      fill="currentColor"
      stroke-width="0"
      viewBox="0 0 16 16"
      height="1em"
      width="1em"
      xmlns="http://www.w3.org/2000/svg"
      {@rest}
    >
      <path d="M8 9.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3z"></path>
    </svg>
    """
  end
end
