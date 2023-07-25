defmodule ScrumPokerWeb.Plugs.SubdomainRedirect do
  import Plug.Conn

  def init(opts) do
    opts
  end

  def call(conn, _options) do
    if has_subdomain?(conn.host) do
      conn
      |> Phoenix.Controller.redirect(external: "https://scrumpoker.org")
      |> halt
    else
      conn
    end
  end

  defp has_subdomain?(host) do
    Regex.match?(~r(https?:\/\/[a-z0-9]+[.]scrumpoker[.]org), host)
  end
end
