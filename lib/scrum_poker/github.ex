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
    {:error, %{}}

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

  @doc """
  Get a user's details from an oauth token. [See here](https://docs.github.com/en/rest/users/users)

  ## Examples

    get_user("gho_123xxx")
    {:ok, %{"login" => "octocat"}}

    get_user("1234", "rke02@k0le_-2")
    {:error, %{}}

  """
  def get_user(oauth_token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.github.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer " <> oauth_token}]}
    ]

    result =
      middleware
      |> Tesla.client()
      |> Tesla.get("/user")

    with {:ok, %{body: body}} <- result do
      {:ok, __MODULE__.User.from_response(body)}
    end
  end

  defmodule User do
    defstruct [:avatar_url, :profile_url, :display_name]

    def from_response(body) do
      %User{
        avatar_url: body["avatar_url"],
        profile_url: body["html_url"],
        display_name: body["name"]
      }
    end
  end

  @doc """
  Get a user's primary email from an oauth token. [See here](https://docs.github.com/en/rest/users/emails)

  ## Examples

    get_user_primary_email("gho_123xxx")
    {:ok, "octocat@example.com"}

    get_user_primary_email("gho_123xxx")
    {:error, %{}}

  """
  def get_user_primary_email(oauth_token) do
    middleware = [
      {Tesla.Middleware.BaseUrl, "https://api.github.com"},
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, [{"Authorization", "Bearer " <> oauth_token}]}
    ]

    result =
      middleware
      |> Tesla.client()
      |> Tesla.get("/user/emails")

    with {:ok, %{body: body}} <- result do
      {:ok, Enum.find_value(body, &primary_email/1)}
    end
  end

  defp primary_email(%{"primary" => true, "email" => email}) do
    email
  end

  defp primary_email(_) do
    nil
  end

  defp client_id, do: ScrumPoker.config([:github, :client_id])
  defp client_secret, do: ScrumPoker.config([:github, :client_secret])
end
