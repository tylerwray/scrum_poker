defmodule ScrumPokerWeb.Modal do
  use ScrumPokerWeb, :component

  alias Phoenix.LiveView.JS

  slot(:title, required: true)
  slot(:sub_title)
  slot(:body, required: true)
  slot(:action_button, required: true)

  def modal(assigns) do
    ~H"""
    <div
      id="modal"
      class="fixed inset-0 z-10 hidden"
      aria-labelledby="modal-title"
      role="dialog"
      aria-modal="true"
    >
      <!--
      Background backdrop, show/hide based on modal state.

      Entering: "ease-out duration-300"
        From: "opacity-0"
        To: "opacity-100"
      Leaving: "ease-in duration-200"
        From: "opacity-100"
        To: "opacity-0"
    -->
      <div class="fixed inset-0 bg-gray-800/75"></div>

      <div class="fixed inset-0 z-10 overflow-y-auto">
        <div class="flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0">
          <!--
            Modal panel, show/hide based on modal state.

            Entering: "ease-out duration-300"
              From: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
              To: "opacity-100 translate-y-0 sm:scale-100"
            Leaving: "ease-in duration-200"
              From: "opacity-100 translate-y-0 sm:scale-100"
              To: "opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
          -->
          <div
            id="modal-panel"
            class="relative transform rounded-lg text-left shadow-xl sm:my-8 sm:w-full sm:max-w-lg"
          >
            <div
              class="bg-white dark:bg-gray-900 px-4 pt-5 pb-4 sm:p-6 sm:pb-4 rounded-t-md"
              phx-click-away={hide_modal()}
              phx-window-keydown={hide_modal()}
              phx-key="escape"
            >
              <button
                id="modal-close"
                phx-click={hide_modal()}
                class="hover:bg-stone-200 dark:hover:bg-gray-800 cursor-pointer grid items-center justify-center transition-colors rounded-md absolute right-2 top-2 w-8 h-8 outline-none focus:bg-stone-200 dark:focus:bg-gray-800"
              >
                <Heroicons.x_mark class="w-6 h-6" />
              </button>
              <div class="sm:flex sm:items-start">
                <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                  <h3 class="text-2xl font-medium leading-6 dark:text-gray-50" id="modal-title">
                    <%= render_slot(@title) %>
                  </h3>
                  <div class={"text-sm text-gray-600 dark:text-gray-200 #{if @sub_title, do: "mt-2"}"}>
                    <%= render_slot(@sub_title) %>
                  </div>
                  <div class="mt-6">
                    <%= render_slot(@body) %>
                  </div>
                </div>
              </div>
            </div>
            <div class="bg-stone-100 dark:bg-gray-800 px-4 py-3 flex justify-end gap-2 sm:px-6 rounded-b-md">
              <%= for action_button <- @action_button do %>
                <%= render_slot(action_button) %>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def show_modal(focus_id \\ "#modal-close") do
    js =
      JS.show(
        to: "#modal-panel",
        transition: {"ease-out duration-300", "opacity-0 translate-y-4 scale-95", "opacity-100"}
      )

    js =
      if focus_id do
        JS.focus(js, to: focus_id)
      else
        js
      end

    JS.show(js,
      to: "#modal",
      transition: {"ease-out duration-300", "opacity-0", "opacity-100"}
    )
  end

  def hide_modal do
    %JS{}
    |> JS.hide(
      to: "#modal-panel",
      transition: {"ease-in duration-200", "opacity-100", "opacity-0 translate-y-4 scale-95"}
    )
    |> JS.hide(
      to: "#modal",
      transition: {"ease-in duration-200", "opacity-100", "opacity-0"}
    )
  end
end
