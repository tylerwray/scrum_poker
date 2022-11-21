defmodule ScrumPokerWeb.SettingsLive do
  use ScrumPokerWeb, :live_view
  use Phoenix.Component
  import ScrumPokerWeb.PokerComponents

  alias Phoenix.LiveView.JS
  alias ScrumPoker.Accounts
  alias Phoenix.HTML.Form

  @deck_color_options [
    %{value: "pink_purple_gradient", label: "Pink - Purple"},
    %{value: "orange_blue_gradient", label: "Orange - Blue"},
    %{value: "orange_purple_gradient", label: "Orange - Purple"},
    %{value: "yellow_red_gradient", label: "Yellow - Red"},
    %{value: "teal_yellow_gradient", label: "Teal - Yellow"},
    %{value: "red_green_gradient", label: "Red - Green"}
  ]

  def render(assigns) do
    assigns =
      assigns
      |> assign(:deck_color_options, @deck_color_options)
      |> assign(:changed, not Enum.empty?(assigns.changeset.changes))

    ~H"""
    <div class="mx-auto max-w-6xl p-12">
      <div class={"fixed bottom-0 left-0 p-4 z-10 text-right w-full transition-all duration-200 ease-in #{if not @changed, do: "opacity-0 translate-y-20"} border-t-2 border-gray-700 bg-gray-900"}>
        <.button id="cancel_button" variant="ghost" color="gray" phx-click="reset">
          Cancel
        </.button>
        <.button id="save_button" type="submit" form="user_settings_form">
          Save
        </.button>
      </div>
      <.form
        :let={f}
        id="user_settings_form"
        for={@changeset}
        class="grid md:grid-cols-2 md:gap-x-8 gap-y-8"
        phx-change="validate"
        phx-submit="save"
      >
        <div class="grid h-max gap-y-8 items-start">
          <div role="group" class="grid items-center gap-y-2">
            <%= label(f, :display_name, class: "block text-base text-gray-50") %>
            <%= text_input(f, :display_name,
              autocomplete: "name",
              class:
                "#{if field_has_error?(f, :display_name), do: "border-red-400"} border-1 block w-full rounded-md bg-gray-800 border-gray-700 shadow-sm focus:border-purple-400 focus:ring-purple-400"
            ) %>
            <%= error_tag(f, :display_name) %>
          </div>

          <div role="group" class="grid items-center gap-y-2">
            <%= label(f, :email, class: "block text-base text-gray-50") %>
            <%= text_input(f, :email,
              autocomplete: "email",
              class:
                "#{if field_has_error?(f, :email), do: "border-red-400"} border-1 block w-full rounded-md bg-gray-800 border-gray-700 shadow-sm focus:border-purple-400 focus:ring-purple-400"
            ) %>
            <%= error_tag(f, :email) %>
          </div>
          <.radio_group
            legend="Color Scheme Preference"
            label="Color Scheme"
            name="user[color_scheme]"
            value={f |> Form.input_value(:color_scheme) |> to_string}
          >
            <:radio value="light">
              Light
            </:radio>
            <:radio value="dark">
              Dark
            </:radio>
            <:radio value="system">
              System
            </:radio>
          </.radio_group>
        </div>
        <fieldset class="grid items-center gap-y-2 ">
          <legend class="sr-only">
            Deck color
          </legend>

          <p class="block text-base text-gray-50">
            Deck color
          </p>

          <div class="grid grid-cols-2 md:grid-cols-3 justify-items-center gap-x-2 gap-y-4 group">
            <%= for option <- @deck_color_options do %>
              <input
                id={"deck_color-#{option.value}"}
                name="user[deck_color]"
                value={option.value}
                type="radio"
                class="hidden"
                checked={option.value == Form.input_value(f, :deck_color)}
              />
              <label for={"deck_color-#{option.value}"} class="text-center">
                <.card
                  is_flipped
                  is_selected={option.value == Form.input_value(f, :deck_color)}
                  color={option.value}
                >
                  5
                </.card>
                <div class="pt-2"><%= option.label %></div>
              </label>
            <% end %>
          </div>
        </fieldset>
      </.form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    current_user = socket.assigns.current_user

    socket =
      socket
      |> assign(:deck_color, current_user.deck_color)
      |> assign(:changeset, Accounts.change_user(current_user))

    {:ok, socket}
  end

  def handle_event("reset", _params, socket) do
    socket = assign(socket, :changeset, Accounts.change_user(socket.assigns.current_user))

    {:noreply, socket}
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      socket.assigns.current_user
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"user" => params}, socket) do
    current_user = socket.assigns.current_user

    case Accounts.update_user(current_user, params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(:current_user, user)
         |> assign(:changeset, Accounts.change_user(user))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
