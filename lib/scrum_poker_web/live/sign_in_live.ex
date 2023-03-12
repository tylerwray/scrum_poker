defmodule ScrumPokerWeb.SignInLive do
  use ScrumPokerWeb, :live_view

  alias ScrumPoker.Github
  alias ScrumPokerWeb.JoinGameForm

  def render(assigns) do
    ~H"""
    <div class="container mx-auto pt-[15vh]">
      <div class="border-gray-700 border-2 py-8 px-4 shadow rounded-lg mt-8 mx-auto w-full max-w-md">
        <div class="pb-4 sm:mx-auto sm:w-full sm:max-w-md">
          <div class="bg-stone-200 dark:bg-gray-50 rounded-full mx-auto w-24 h-24 grid justify-center items-center">
            <img class="h-20 p-2 w-20" src="images/poker.png" alt="Poker" />
          </div>
          <h2 class="mt-6 text-center text-3xl font-base dark:text-gray-100">
            Sign in to your account
          </h2>
        </div>

        <div class="space-y-6 grid justify-center">
          <a
            href={Github.oauth_url()}
            class="flex items-center gap-2 justify-center py-2 px-4 border border-transparent rounded-md shadow-sm text-sm font-medium text-white bg-gray-800 hover:bg-gray-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              width="24"
              height="24"
              fill="white"
              viewBox="0 0 24 24"
            >
              <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
            </svg>
            Continue with GitHub
          </a>
        </div>
      </div>

      <div class="relative flex py-5 items-center w-80 mx-auto">
        <div class="flex-grow border-t border-gray-700"></div>
        <span class="flex-shrink mx-4 text-gray-600 dark:text-gray-300">or</span>
        <div class="flex-grow border-t border-gray-700"></div>
      </div>

      <.live_component module={JoinGameForm} id="join_form" />
    </div>
    """
  end
end
