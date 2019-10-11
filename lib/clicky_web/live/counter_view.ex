defmodule ClickyWeb.CounterView do
  use Phoenix.LiveView

  def render(assigns) do
    ClickyWeb.PageView.render("counter.html", assigns)
  end

  def mount(_session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  def handle_event("increment", _value, socket) do
    IO.puts "YO!"
    {:noreply, assign(socket, count: 1)}
  end
end
