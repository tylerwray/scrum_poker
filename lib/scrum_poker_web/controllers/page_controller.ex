defmodule ScrumPokerWeb.PageController do
  use ScrumPokerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
