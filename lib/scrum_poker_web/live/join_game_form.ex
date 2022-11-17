defmodule ScrumPokerWeb.JoinGameForm do
  use Phoenix.LiveComponent

  import ScrumPokerWeb.FormComponents

  alias ScrumPoker.Poker

  attr :id, :string, required: true

  def render(assigns) do
    assigns = assign_new(assigns, :error, fn -> nil end)

    ~H"""
    <form
      id={@id}
      class="grid justify-center items-center gap-2"
      action="#"
      method="POST"
      phx-change="validate"
      phx-submit="join_game"
      phx-target={@myself}
    >
      <div role="group" class="grid items-center grid-cols-[1fr_auto] gap-y-2 gap-x-4">
        <label for="join_code" class="block text-xl font-base text-gray-50 col-span-2">
          Join a game
        </label>
        <input
          id="join_code"
          autocomplete="join_code"
          class={"#{if @error, do: "border-red-400"} border-1 block w-full rounded-md bg-gray-800 border-gray-700 shadow-sm focus:border-purple-400 focus:ring-purple-400"}
          max-length="4"
          name="join_code"
          placeholder="J43K"
          type="text"
        />
        <.button variant="outline" type="submit">
          <span class="pr-2">Join</span> <Heroicons.arrow_right class="w-4 h-4 stroke-2" />
        </.button>
        <span class="text-red-400 text-sm h-12 col-span-2"><%= @error %></span>
      </div>
    </form>
    """
  end

  def handle_event("validate", %{"join_code" => join_code}, socket) do
    socket = assign(socket, error: nil)

    cond do
      join_code == "" ->
        {:noreply, socket}

      String.length(join_code) > 4 ->
        {:noreply, assign(socket, error: "Must be 4 characters.")}

      not Poker.join_code_valid?(join_code) ->
        {:noreply, assign(socket, error: "Must only contain letters and numbers.")}

      true ->
        {:noreply, socket}
    end
  end

  def handle_event("join_game", %{"join_code" => join_code}, socket) do
    socket = assign(socket, error: nil)

    cond do
      join_code == "" ->
        {:noreply, assign(socket, error: "Must include join code.")}

      String.length(join_code) != 4 ->
        {:noreply, assign(socket, error: "Must be 4 characters.")}

      not Poker.join_code_valid?(join_code) ->
        {:noreply, assign(socket, error: "Must only contain letters and numbers.")}

      not Poker.join_code_exists?(join_code) ->
        {:noreply, assign(socket, error: "Game does not exist.")}

      true ->
        {:noreply, push_navigate(socket, to: "/games/#{join_code}")}
    end
  end
end
