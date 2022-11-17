defmodule ScrumPokerWeb.HomeLive do
  use ScrumPokerWeb, :live_view
  use Phoenix.Component

  import ScrumPokerWeb.Modal
  alias ScrumPokerWeb.JoinGameForm
  alias ScrumPoker.Poker

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-6xl p-12 grid sm:grid-cols-2 items-center">
      <div>
        <h1 class="text-3xl sm:text-4xl font-bold text-gray-50">Ready to play?</h1>
        <div class="text-xl sm:text-2xl font-light tracking-wide text-gray-400">
          Start a game and invite your team.
        </div>
        <div class="pt-12">
          <.button variant="solid" size="lg" phx-click={show_modal("#description")}>
            New Game
          </.button>
        </div>
      </div>
      <.modal>
        <:title>New game</:title>
        <:sub_title>Give your game a short description and choose the deck sequence.</:sub_title>
        <:body>
          <form id="new_game_form" action="#" method="POST" class="pb-4" phx-submit="new_game">
            <div role="group" class="grid items-center gap-y-2">
              <label for="description" class="block text-base text-gray-50">
                Description
              </label>
              <input
                id="description"
                autocomplete="description"
                class={"#{if @description_error, do: "border-red-400"} border-1 block w-full rounded-md bg-gray-800 border-gray-700 shadow-sm focus:border-purple-400 focus:ring-purple-400"}
                name="description"
                type="text"
              />
              <span class="text-red-400 text-sm h-6"><%= @description_error %></span>
            </div>
            <.radio_group legend="Deck Sequence" label="Deck Sequence" name="deck_sequence">
              <:radio value="fibonacci" checked>
                Fibonacci
                <div class="text-gray-400">1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144</div>
              </:radio>
              <:radio value="linear">
                Linear
                <div class="text-gray-400">1, 2, 3, 4, 5, 6, 7, 8, 9, 10</div>
              </:radio>
              <:radio value="tshirt">
                T-Shirt
                <div class="text-gray-400">XS, SM, MD, LG, XL</div>
              </:radio>
            </.radio_group>
          </form>
        </:body>
        <:action_button>
          <.button variant="ghost" color="gray" phx-click={hide_modal()}>Cancel</.button>
        </:action_button>
        <:action_button>
          <.button variant="solid" form="new_game_form">Start game</.button>
        </:action_button>
      </.modal>
      <.live_component module={JoinGameForm} id="join_form" />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, %{
       description_error: nil
     })}
  end

  def handle_event("new_game", params, socket) do
    user_uuid = socket.assigns.current_user.uuid

    params =
      params
      |> Map.put("join_code", Poker.generate_join_code())
      |> Map.put("created_by", user_uuid)

    Poker.delete_existing_user_games(user_uuid)

    case Poker.create_game(params) do
      {:ok, game} ->
        {:noreply,
         socket
         |> put_flash(:info, "Welcome!")
         |> push_navigate(to: "/games/#{game.join_code}/host")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
