defmodule ScrumPokerWeb.Layout do
  use ScrumPokerWeb, :component

  alias Phoenix.LiveView.JS

  attr :display_name, :string, required: true

  def anonymous_nav(assigns) do
    ~H"""
    <nav class="grid sm:grid-cols-[1fr_auto_auto] grid-cols-1 gap-4 items-center sm:justify-items-start justify-items-center p-6 max-w-6xl mx-auto">
      <.link
        role="menuitem"
        navigate="/signin"
        class="outline-none px-2 py-1 flex gap-2 items-center rounded-lg hover text-gray-800 dark:text-gray-100 hover:bg-gray-600/10 dark:hover:bg-gray-300/20"
      >
        <%!-- Spade icon --%>
        <svg
          xmlns="http://www.w3.org/2000/svg"
          width="16"
          height="16"
          fill="currentColor"
          class="bi bi-suit-spade-fill"
          viewBox="0 0 16 16"
        >
          <path d="M7.184 11.246A3.5 3.5 0 0 1 1 9c0-1.602 1.14-2.633 2.66-4.008C4.986 3.792 6.602 2.33 8 0c1.398 2.33 3.014 3.792 4.34 4.992C13.86 6.367 15 7.398 15 9a3.5 3.5 0 0 1-6.184 2.246 19.92 19.92 0 0 0 1.582 2.907c.231.35-.02.847-.438.847H6.04c-.419 0-.67-.497-.438-.847a19.919 19.919 0 0 0 1.582-2.907z" />
        </svg>
        <span>Sign in</span>
      </.link>
      <.link
        role="menuitem"
        href="https://github.com/tylerwray/scrum_poker"
        target="_blank"
        class="outline-none px-2 py-1 flex gap-2 items-center rounded-lg hover text-gray-800 dark:text-gray-100 hover:bg-gray-600/10 dark:hover:bg-gray-300/20"
      >
        <svg
          height="20"
          aria-hidden="true"
          viewBox="0 0 16 16"
          version="1.1"
          width="20"
          data-view-component="true"
          class="fill-[#24292f] dark:fill-white"
        >
          <path d="M8 0c4.42 0 8 3.58 8 8a8.013 8.013 0 0 1-5.45 7.59c-.4.08-.55-.17-.55-.38 0-.27.01-1.13.01-2.2 0-.75-.25-1.23-.54-1.48 1.78-.2 3.65-.88 3.65-3.95 0-.88-.31-1.59-.82-2.15.08-.2.36-1.02-.08-2.12 0 0-.67-.22-2.2.82-.64-.18-1.32-.27-2-.27-.68 0-1.36.09-2 .27-1.53-1.03-2.2-.82-2.2-.82-.44 1.1-.16 1.92-.08 2.12-.51.56-.82 1.28-.82 2.15 0 3.06 1.86 3.75 3.64 3.95-.23.2-.44.55-.51 1.07-.46.21-1.61.55-2.33-.66-.15-.24-.6-.83-1.23-.82-.67.01-.27.38.01.53.34.19.73.9.82 1.13.16.45.68 1.31 2.69.94 0 .67.01 1.3.01 1.49 0 .21-.15.45-.55.38A7.995 7.995 0 0 1 0 8c0-4.42 3.58-8 8-8Z">
          </path>
        </svg>
        Github <Heroicons.arrow_top_right_on_square class="w-4 h-4" />
      </.link>
      <h2 class="text-lg"><%= @display_name %></h2>
    </nav>
    """
  end

  def nav(assigns) do
    ~H"""
    <%= if @current_user do %>
      <nav class="grid sm:grid-cols-[1fr_auto_auto] grid-cols-1 gap-4 items-center sm:justify-items-start justify-items-center px-12 py-6 max-w-6xl mx-auto">
        <.link
          role="menuitem"
          navigate="/home"
          class="outline-none px-2 py-1 flex gap-2 items-center rounded-lg hover text-gray-800 dark:text-gray-100 hover:bg-gray-600/10 dark:hover:bg-gray-300/20"
        >
          <%!-- Spade icon --%>
          <svg
            xmlns="http://www.w3.org/2000/svg"
            width="16"
            height="16"
            fill="currentColor"
            class="bi bi-suit-spade-fill"
            viewBox="0 0 16 16"
          >
            <path d="M7.184 11.246A3.5 3.5 0 0 1 1 9c0-1.602 1.14-2.633 2.66-4.008C4.986 3.792 6.602 2.33 8 0c1.398 2.33 3.014 3.792 4.34 4.992C13.86 6.367 15 7.398 15 9a3.5 3.5 0 0 1-6.184 2.246 19.92 19.92 0 0 0 1.582 2.907c.231.35-.02.847-.438.847H6.04c-.419 0-.67-.497-.438-.847a19.919 19.919 0 0 0 1.582-2.907z" />
          </svg>
          <span>Home</span>
        </.link>
        <.link
          role="menuitem"
          href="https://github.com/tylerwray/scrum_poker"
          target="_blank"
          class="outline-none px-2 py-1 flex gap-2 items-center rounded-lg hover text-gray-800 dark:text-gray-100 hover:bg-gray-600/10 dark:hover:bg-gray-300/20"
        >
          <svg
            height="20"
            aria-hidden="true"
            viewBox="0 0 16 16"
            version="1.1"
            width="20"
            data-view-component="true"
            class="fill-[#24292f] dark:fill-white"
          >
            <path d="M8 0c4.42 0 8 3.58 8 8a8.013 8.013 0 0 1-5.45 7.59c-.4.08-.55-.17-.55-.38 0-.27.01-1.13.01-2.2 0-.75-.25-1.23-.54-1.48 1.78-.2 3.65-.88 3.65-3.95 0-.88-.31-1.59-.82-2.15.08-.2.36-1.02-.08-2.12 0 0-.67-.22-2.2.82-.64-.18-1.32-.27-2-.27-.68 0-1.36.09-2 .27-1.53-1.03-2.2-.82-2.2-.82-.44 1.1-.16 1.92-.08 2.12-.51.56-.82 1.28-.82 2.15 0 3.06 1.86 3.75 3.64 3.95-.23.2-.44.55-.51 1.07-.46.21-1.61.55-2.33-.66-.15-.24-.6-.83-1.23-.82-.67.01-.27.38.01.53.34.19.73.9.82 1.13.16.45.68 1.31 2.69.94 0 .67.01 1.3.01 1.49 0 .21-.15.45-.55.38A7.995 7.995 0 0 1 0 8c0-4.42 3.58-8 8-8Z">
            </path>
          </svg>
          Github <Heroicons.arrow_top_right_on_square class="w-4 h-4" />
        </.link>
        <.dropdown id="user-tile">
          <:img src={@current_user.avatar_url} />
          <:title><%= @current_user.display_name %></:title>
          <:subtitle><%= @current_user.email %></:subtitle>
          <:link navigate="/profile/settings">
            <div class="grid grid-cols-[auto_1fr] gap-2">
              <Heroicons.cog_6_tooth solid class="w-5 h-5" />
              <span>Settings</span>
            </div>
          </:link>
          <:link href="/signout" method={:delete}>
            <div class="grid grid-cols-[auto_1fr] gap-2">
              <Heroicons.arrow_right_on_rectangle solid class="w-5 h-5" />
              <span>Sign out</span>
            </div>
          </:link>
        </.dropdown>
      </nav>
    <% end %>
    """
  end

  @doc """
  Returns a button triggered dropdown with aria keyboard and focus supporrt.

  Accepts the follow slots:

    * `:id` - The id to uniquely identify this dropdown
    * `:img` - The optional img to show beside the button title
    * `:title` - The button title
    * `:subtitle` - The button subtitle

  ## Examples

    <.dropdown id="user-dropdown">
      <:img src={@current_user.avatar_url} />
      <:title><%= @current_user.display_name %></:title>
      <:subtitle><%= @current_user.email %></:subtitle>
      <:link navigate={Routes.settings_path(Endpoint, :edit)}>Settings</:link>
      <:link href={Routes.o_auth_callback_path(Endpoint, :sign_out)} method={:delete}>
        Sign out
      </:link>
    </.dropdown>
  """
  attr :id, :string, required: true

  slot(:inner_block, required: true)

  slot :img do
    attr :src, :string, required: true
  end

  slot(:title)
  slot(:subtitle)

  slot :link do
    attr :href, :string
    attr :navigate, :string
    attr :method, :atom
  end

  def dropdown(assigns) do
    ~H"""
    <div class="relative max-w-md">
      <button
        id={@id}
        type="button"
        class="w-full rounded-md px-3.5 py-2 shadow dark:text-gray-100 hover:bg-gray-600/20 dark:hover:bg-gray-300/20 outline-none bg-transparent border-2 border-gray-700 focus-visible:ring-2 ring-offset-2 ring-purple-600 dark:ring-purple-400 dark:ring-offset-gray-900"
        phx-click={show_dropdown("##{@id}-dropdown")}
        phx-hook="Menu"
        aria-haspopup="true"
      >
        <span class="grid grid-cols-[auto_1fr_auto] justify-start items-center">
          <%= for img <- @img do %>
            <img
              class="w-10 h-10 bg-gray-300 rounded-full flex-shrink-0"
              alt=""
              {assigns_to_attributes(img)}
            />
          <% end %>
          <div class="px-4 text-left">
            <div class="dark:text-gray-100 font-medium truncate">
              <%= render_slot(@title) %>
            </div>
            <div class="text-gray-500 dark:text-gray-50 text-sm truncate">
              <%= render_slot(@subtitle) %>
            </div>
          </div>
          <svg
            class="flex-shrink-0 h-5 w-5 text-gray-900 dark:text-gray-400"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
          >
            <path
              fill-rule="evenodd"
              d="M10 3a1 1 0 01.707.293l3 3a1 1 0 01-1.414 1.414L10 5.414 7.707 7.707a1 1 0 01-1.414-1.414l3-3A1 1 0 0110 3zm-3.707 9.293a1 1 0 011.414 0L10 14.586l2.293-2.293a1 1 0 011.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z"
              clip-rule="evenodd"
            >
            </path>
          </svg>
        </span>
      </button>
      <div
        id={"#{@id}-dropdown"}
        class="hidden origin-top absolute right-0 left-0 mt-1 rounded-md shadow-lg bg-white z-10 border-gray-700 border-2 dark:bg-gray-900 ring-1 ring-black ring-opacity-5 divide-y divide-gray-200"
        role="menu"
        phx-click-away={hide_dropdown("##{@id}-dropdown")}
        aria-labelledby={@id}
      >
        <div class="py-1" role="none">
          <%= for link <- @link do %>
            <.link
              tabindex="-1"
              role="menuitem"
              phx-click={hide_dropdown("##{@id}-dropdown")}
              class="block px-4 py-2 dark:bg-gray-900 text-sm dark:text-gray-50 hover:bg-gray-600/20 dark:hover:bg-gray-800 outline-none focus:bg-gray-600/20 bg-dark:focus:bg-gray-800"
              {link}
            >
              <%= render_slot(link) %>
            </.link>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def show_dropdown(to) do
    JS.show(
      to: to,
      transition:
        {"transition ease-out duration-120", "transform opacity-0 scale-95",
         "transform opacity-100 scale-100"}
    )
    |> JS.set_attribute({"aria-expanded", "true"}, to: to)
  end

  def hide_dropdown(to) do
    JS.hide(
      to: to,
      transition:
        {"transition ease-in duration-120", "transform opacity-100 scale-100",
         "transform opacity-0 scale-95"}
    )
    |> JS.remove_attribute("aria-expanded", to: to)
  end
end
