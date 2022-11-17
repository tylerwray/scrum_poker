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

  attr :color, :string, default: "bg-gradient-to-r from-[#B83280] to-[#553C9A]"
  attr :is_flipped, :boolean, default: false
  attr :is_selected, :boolean, default: false
  attr :size, :string, default: "sm"
  attr :rest, :global

  slot(:inner_block)

  def card(assigns) do
    assigns =
      assigns
      |> assign(:base_classes, @base_classes)
      |> assign(:size_classes, @size_classes[assigns.size])

    ~H"""
    <div class="card-scene w-max">
      <div class={"card #{@size_classes} #{if @is_flipped, do: "is-flipped"}"} {@rest}>
        <div class={"card-face #{@base_classes} #{@color}"} />
        <div class={"card-face card-back #{@base_classes} #{@color} #{if @is_selected, do: "ring-4 ring-green-600 ring-offset-4 ring-offset-gray-900"}"}>
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
