defmodule ClickyWeb.PageController do
  use ClickyWeb, :controller
  alias Phoenix.LiveView

  def index(conn, _params) do
    LiveView.Controller.live_render(conn, ClickyWeb.CounterView, session: %{})
  end
end
