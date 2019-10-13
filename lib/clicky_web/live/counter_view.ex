defmodule ClickyWeb.CounterView do
  use Phoenix.LiveView
  alias Clicky.Counter

  @topic "counter"

  def render(assigns) do
    ClickyWeb.PageView.render("counter.html", assigns)
  end

  def mount(_session, socket) do
    ClickyWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, count: Counter.value(), status: "ready")}
  end

  def handle_event("increment", _value, socket) do
    new_count = Counter.increment()
    ClickyWeb.Endpoint.broadcast_from(self(), @topic, "increment", %{count: new_count})
    {:noreply, assign(socket, count: new_count)}
  end

  def handle_info(%{topic: @topic, payload: state}, socket) do
    IO.puts "In the handle_info with state = #{inspect(state)}"
    {:noreply, assign(socket, state)}
  end
end
