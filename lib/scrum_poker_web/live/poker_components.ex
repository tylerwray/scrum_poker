defmodule ScrumPokerWeb.PokerComponents do
  use ScrumPokerWeb, :component

  alias Phoenix.LiveView.JS

  @base_classes "absolute w-full h-full text-white rounded-md cursor-pointer focus:outline-none focus:ring flex justify-center items-center"

  # 2/3 ratio w/h
  @size_classes %{
    "xs" => "w-16 h-24 text-3xl",
    "sm" => "w-24 h-36 text-5xl",
    "md" => "w-40 h-[15rem] text-6xl",
    "lg" => "w-64 h-96 text-huge"
  }

  @color_classes %{
    "pink_purple_gradient" => "bg-gradient-to-r from-purple-500 to-pink-500",
    "orange_blue_gradient" => "bg-gradient-to-b from-orange-500 to-blue-500",
    "orange_purple_gradient" => "bg-gradient-to-tr from-orange-400 to-purple-500",
    "yellow_red_gradient" => "bg-gradient-to-tl from-red-500 to-yellow-400",
    "teal_yellow_gradient" => "bg-gradient-to-br from-teal-600 to-yellow-400",
    "red_green_gradient" => "bg-gradient-to-bl from-red-500 to-green-500"
  }

  attr :color, :string
  attr :is_flipped, :boolean, default: false
  attr :is_selected, :boolean, default: false
  attr :size, :string, default: "sm"
  attr :rest, :global

  slot(:inner_block)

  def card(assigns) do
    color = Map.get(assigns, :color) || "pink_purple_gradient"

    assigns =
      assigns
      |> assign(:base_classes, @base_classes)
      |> assign(:size_classes, @size_classes[assigns.size])
      |> assign(:color_classes, @color_classes[color])

    ~H"""
    <div class="card-scene">
      <div class={"card #{@size_classes} #{if @is_flipped, do: "is-flipped"} mx-auto"} {@rest}>
        <div class={"card-face #{@base_classes} #{@color_classes}"} />
        <div class={"card-face card-back #{@base_classes} #{@color_classes} #{if @is_selected, do: "ring-4 ring-green-500 dark:ring-green-600 ring-offset-4 dark:ring-offset-gray-900"}"}>
          <%= if @is_selected do %>
            <span class="bg-green-500 dark:bg-green-600 absolute top-1 right-1 rounded-full p-1">
              <Heroicons.check class="w-5 h-5 stroke-2" />
            </span>
          <% end %>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  attr :game, ScrumPoker.Poker.Game

  def game_description(assigns) do
    assigns =
      assigns
      |> assign(
        :share_game_link,
        ScrumPokerWeb.Router.Helpers.game_url(
          ScrumPokerWeb.Endpoint,
          :index,
          assigns.game.join_code
        )
      )
      |> assign(
        :deck_sequence,
        assigns.game.deck_sequence
        |> Atom.to_string()
        |> String.capitalize()
      )

    ~H"""
    <div>
      <div
        class="group flex items-center gap-2"
        phx-click={JS.dispatch("game:copy_share_link", detail: %{link: @share_game_link})}
      >
        <h2 class="cursor-pointer text-4xl font-bold">
          <%= @game.join_code %>
        </h2>
        <.button
          class="opacity-0 -translate-x-4 group-hover:opacity-100 group-hover:translate-x-0 w-24"
          variant="ghost"
          color="gray"
          size="sm"
        >
          <div id="copy-game-link-button" class="flex gap-2 items-center">
            <Heroicons.link class="w-4 h-4" /> Copy link
          </div>
          <div id="copied-game-link" class="hidden gap-2 items-center">
            <Heroicons.check class="w-5 h-5 stroke-green-600 stroke-2" /> Copied
          </div>
        </.button>
      </div>
      <p class="max-w-xl">
        <%= @deck_sequence %> - <%= @game.description %>
      </p>
    </div>
    """
  end
end
