defmodule ScrumPoker.Github do
  @moduledoc """
  A Service module for interacting with Github.
  """

  require Logger

  def oauth_url do
    "https://github.com/login/oauth/authorize?client_id=#{client_id()}&state=#{random_string()}&scope=user:email"
  end

  def random_string do
    binary = <<
      System.system_time(:nanosecond)::64,
      :erlang.phash2({node(), self()})::16,
      :erlang.unique_integer()::16
    >>

    binary
    |> Base.url_encode64()
    |> String.replace(["/", "+"], "-")
  end

  @doc """
  Exchange an OAuth redirect code for an
  access token. [See here](https://docs.github.com/en/developers/apps/building-oauth-apps/authorizing-oauth-apps#2-users-are-redirected-back-to-your-site-by-github)

  ## Examples

    exchange_oauth_code("1234", "rke02@k0le_-2")
    {:ok, %{"access_token" => "gho_123xxx"}}

    exchange_oauth_code("1234", "rke02@k0le_-2")
    :error

  """
  def exchange_oauth_code(code, state) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://github.com"},
      Tesla.Middleware.FormUrlencoded
    ]

    body = %{
      "code" => code,
      "state" => state,
      "client_secret" => client_secret(),
      "client_id" => client_id()
    }

    result =
      middleware
      |> Tesla.client()
      |> Tesla.post("/login/oauth/access_token", body)

    with {:ok, %{body: %{"access_token" => access_token}}} <- result do
      {:ok, access_token}
    end
  end

  defp client_id, do: ScrumPoker.config([:github, :client_id])
  defp client_secret, do: ScrumPoker.config([:github, :client_secret])
end
