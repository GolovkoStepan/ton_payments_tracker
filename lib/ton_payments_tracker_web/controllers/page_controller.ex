defmodule TonPaymentsTrackerWeb.PageController do
  use TonPaymentsTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
