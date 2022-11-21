defmodule ScrumPokerWeb.PokerComponents do
  use ScrumPokerWeb, :component

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
    color = Map.get(assigns, :color) ||  "pink_purple_gradient"

    assigns =
      assigns
      |> assign(:base_classes, @base_classes)
      |> assign(:size_classes, @size_classes[assigns.size])
      |> assign(:color_classes, @color_classes[color])

    ~H"""
    <div class="card-scene">
      <div class={"card #{@size_classes} #{if @is_flipped, do: "is-flipped"} mx-auto"} {@rest}>
        <div class={"card-face #{@base_classes} #{@color_classes}"} />
        <div class={"card-face card-back #{@base_classes} #{@color_classes} #{if @is_selected, do: "ring-4 ring-green-600 ring-offset-4 ring-offset-gray-900"}"}>
          <%= if @is_selected do %>
            <span class="bg-green-600 absolute top-1 right-1 rounded-full p-1">
              <Heroicons.check class="w-5 h-5 stroke-2" />
            </span>
          <% end %>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end
end
