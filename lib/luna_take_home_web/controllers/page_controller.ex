defmodule LunaTakeHomeWeb.PageController do
  use LunaTakeHomeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
