defmodule ClickyWeb.CounterView do
  use Phoenix.LiveView
  alias Clicky.{Counter, UserStore}

  @topic "counter"

  def render(assigns) do
    ClickyWeb.PageView.render("counter.html", assigns)
  end

  def mount(session, socket) do
    ClickyWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, count: session.count, user_id: session.user_id, user_counts: build_user_counts(), status: "ready")}
  end

  def handle_event("increment", %{"user" => user_id}, socket) do
    new_count = Counter.increment(user_id)
    user_counts = build_user_counts()
    ClickyWeb.Endpoint.broadcast_from(self(), @topic, "increment", %{count: new_count, user_counts: user_counts})
    {:noreply, assign(socket, count: new_count, user_counts: user_counts)}
  end

  def handle_info(%{topic: @topic, payload: state}, socket) do
    IO.puts "In the handle_info with state = #{inspect(state)}"
    {:noreply, assign(socket, state)}
  end


  defp build_user_counts do
    Counter.user_counts()
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      username = case UserStore.fetch_user(k) do
        {:ok, ""} -> "annonymous"
        {:ok, handle} -> handle
        {:error, _} -> "annonymous"
      end
      Map.put(acc, username, v)
    end)
  end
end
