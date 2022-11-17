defmodule ScrumPokerWeb.FormComponents do
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  attr :class, :string, default: ""
  attr :color, :string, default: "primary"
  attr :form, :string
  attr :rest, :global
  attr :size, :string, default: "base"
  attr :variant, :string, default: "solid"

  slot(:inner_block, required: true)

  @button_colors %{
    "outline" => %{
      "primary" =>
        "shadow text-purple-400 hover:bg-purple-400/20 bg-transparent border-2 border-current ring-purple-400 ring-offset-gray-900",
      "gray" => ""
    },
    "solid" => %{
      "primary" =>
        "shadow bg-purple-400 hover:bg-purple-400/80 text-gray-900 ring-purple-400 ring-offset-gray-900",
      "gray" => ""
    },
    "ghost" => %{
      "primary" =>
        "bg-transparent shadow-none hover:shadow text-purple-400 hover:bg-purple-400/20 ring-purple-400 ring-offset-gray-900",
      "gray" =>
        "bg-transparent shadow-none hover:shadow text-gray-200 hover:bg-gray-300/20 ring-current ring-offset-gray-900"
    },
    "link" => %{
      "primary" =>
        "shadow-none bg-transparent text-purple-400 hover:underline ring-purple-400 ring-offset-gray-900",
      "gray" => ""
    }
  }

  @button_sizes %{
    "base" => "h-10 min-w-[2.5rem] text-md px-4",
    "lg" => "h-12 min-w-[3rem] text-lg px-6"
  }

  @base_button_classes "inline-flex appearance-none items-center justify-center select-none relative whitespace-nowrap align-middle focus:outline-none focus-visible:ring-2 ring-offset-4 rounded-md font-semibold leading-tight transition-colors duration-200"

  def button(assigns) do
    extra = assigns_to_attributes(assigns, [:class, :color, :rest, :size, :variant])

    assigns =
      assigns
      |> assign(:base_classes, @base_button_classes)
      |> assign(:size_classes, @button_sizes[assigns.size])
      |> assign(:color_classes, @button_colors[assigns.variant][assigns.color])
      |> assign(:extra, extra)

    ~H"""
    <button class={"#{@base_classes} #{@size_classes} #{@class} #{@color_classes}"} {@extra} {@rest}>
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  attr :label, :string, required: true
  attr :legend, :string, required: true
  attr :name, :string, required: true
  attr :class, :string, default: ""

  slot :radio do
    attr :value, :string, required: true
    attr :checked, :boolean
  end

  def radio_group(assigns) do
    ~H"""
    <fieldset class={"grid items-center gap-y-2 #{@class}"}>
      <legend class="sr-only">
        <%= @label %>
      </legend>

      <p class="block text-base text-gray-50">
        <%= @label %>
      </p>

      <div class="grid grid-cols-[auto_1fr] gap-x-2 gap-y-4">
        <%= for radio <- @radio do %>
          <input
            id={"#{@name}-#{radio.value}"}
            name={@name}
            value={radio.value}
            type="radio"
            class="mt-[2px] border-gray-700 bg-gray-800 text-purple-400/90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-purple-400/90 focus:ring-offset-gray-900"
            {assigns_to_attributes(radio)}
          />
          <label for={"#{@name}-#{radio.value}"} class="text-sm font-medium text-gray-50">
            <%= render_slot(radio) %>
          </label>
        <% end %>
      </div>
    </fieldset>
    """
  end

  attr :id, :string, required: true
  attr :label, :string, required: true
  attr :name, :string, required: true

  slot :option do
    attr :name, :string, required: true
    attr :value, :string, required: true
  end

  def select(assigns) do
    ~H"""
    <div id={@id} class="grid items-center gap-y-2 gap-x-4">
      <label
        id={"#{@id}-select-label"}
        class="block font-base text-gray-50"
        for={"#{@id}-hidden-input"}
      >
        <%= @label %>
      </label>
      <input class="hidden" id={"#{@id}-hidden-input"} defaultvalue={List.first(@option).value} />
      <%!-- <select id="hidden-select" name={@name} class="hidden">
        <%= for option <- @option do %>
          <option value={option.value} id={"option-#{option.value}"}></option>
        <% end %>
      </select> --%>
      <div class="relative">
        <button
          type="button"
          class="relative w-full cursor-pointer rounded-md border border-gray-700 bg-gray-800 pl-3 py-2 text-left focus:border-purple-400 focus:outline-none focus:ring-1 focus:ring-purple-400"
          phx-click={toggle_modal()}
          phx-click-away={JS.hide(to: "##{@id}-select-popover")}
          aria-haspopup="listbox"
          aria-expanded="true"
          aria-labelledby={"#{@id}-listbox-label"}
        >
          <%!-- SELECTED Option --%>
          <span>Fibonacci</span>
          <span class="pointer-events-none absolute inset-y-0 right-0 ml-3 flex items-center pr-2">
            <Heroicons.chevron_up_down class="h-5 w-5 text-gray-400" />
          </span>
        </button>
        <!--
          Select popover, show/hide based on select state.

          Entering: ""
            From: ""
            To: ""
          Leaving: "transition ease-in duration-100"
            From: "opacity-100"
            To: "opacity-0"
        -->
        <ul
          id="select-popover"
          class="hidden absolute z-10 mt-1 max-h-56 w-full overflow-auto rounded-md bg-gray-800 py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm"
          tabindex="-1"
          role="listbox"
          aria-labelledby="listbox-label"
          aria-activedescendant="listbox-option-3"
        >
          <!--
            Select option, manage highlight styles based on mouseenter/mouseleave and keyboard navigation.

            Highlighted: "text-white bg-indigo-600", Not Highlighted: "text-gray-900"
          -->
          <%= for option <- @option do %>
            <li
              class="text-gray-50 relative cursor-pointer bg-gray-800 hover:bg-gray-900/75 select-none py-2 pl-3 pr-9"
              id={"listbox-option-#{option.value}"}
              role="option"
              phx-click={JS.set_attribute({"value", option.value}, to: "##{@id}-hidden-input")}
            >
              <span class="font-normal ml-3 block truncate"><%= option.name %></span>
              <!--
              Checkmark, only display for selected option.

              Highlighted: "text-white", Not Highlighted: "text-indigo-600"
            -->
              <span class="text-purple-400 absolute inset-y-0 right-0 flex items-center pr-4">
                <Heroicons.check class="h-5 w-5" />
              </span>
            </li>
          <% end %>
        </ul>
      </div>
    </div>
    """
  end

  defp toggle_modal do
    JS.toggle(
      to: "#select-popover",
      in: {"ease-out duration-200", "opacity-0", "opacity-100"},
      out: {"ease-out duration-200", "opacity-100", "opacity-0"}
    )
  end
end
