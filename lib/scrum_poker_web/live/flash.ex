defmodule ScrumPokerWeb.Flash do
  use ScrumPokerWeb, :component

  alias Phoenix.LiveView.JS

  @level_bg_colors %{
    info: "bg-blue-700",
    error: "bg-red-700"
  }

  @level_icon_bg_colors %{
    info: "bg-blue-700",
    error: "bg-red-700"
  }

  attr :level, :atom, default: :info

  def alert(assigns) do
    # Derived assigns
    assigns =
      assigns
      |> assign(bg_color: @level_bg_colors[assigns.level])
      |> assign(icon_bg_color: @level_icon_bg_colors[assigns.level])
      |> assign(root_id: "flash-#{assigns.level}")
      |> assign(root_id_selector: "#flash-#{assigns.level}")

    ~H"""
    <%= if Phoenix.Component.live_flash(@flash, @level) do %>
      <div
        id={@root_id}
        role="alert"
        class={"grid grid-cols-[auto_minmax(120px,240px)_auto] p-4 items-center gap-4 rounded-md fade-in-scale #{@bg_color} bg-opacity-50"}
        phx-hook="Flash"
      >
        <div class={"rounded-md w-fit p-2 #{@bg_color}"}>
          <%= if @level == :info do %>
            <Heroicons.megaphone class="h-6 w-6" />
          <% else %>
            <svg
              xmlns="http://www.w3.org/2000/svg"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              class="w-6 h-6"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                d="M12 9v3.75m9-.75a9 9 0 11-18 0 9 9 0 0118 0zm-9 3.75h.008v.008H12v-.008z"
              />
            </svg>
          <% end %>
        </div>
        <p class="truncate font-base text-white">
          <%= Phoenix.Component.live_flash(@flash, @level) %>
        </p>
        <button
          type="button"
          class="rounded-md p-2 hover:bg-white/10 focus:outline-none focus:ring-2 focus:ring-white"
          phx-click={hide_flash(@root_id_selector)}
        >
          <span class="sr-only">Dismiss</span>
          <!-- Heroicon name: outline/x-mark -->
          <svg
            class="h-6 w-6 text-white"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            aria-hidden="true"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>
    <% end %>
    """
  end

  defp hide_flash(to) do
    JS.push("lv:clear-flash")
    |> JS.remove_class("fade-in-scale", to: to)
    |> JS.hide(
      to: to,
      transition:
        {"transition ease-in duration-120", "transform opacity-100 scale-100",
         "transform opacity-0 scale-95"}
    )
  end
end
