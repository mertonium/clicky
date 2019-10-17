defmodule ClickyWeb.PageController do
  use ClickyWeb, :controller
  alias Clicky.{Counter, User, UserStore}
  alias Phoenix.LiveView

  def index(conn, _params) do
    conn = Plug.Conn.fetch_cookies(conn)

    render(conn, "login.html", user: %User{})
  end

  def login(conn, params) do
    user = %User{id: UUID.uuid4(:hex), handle: params["user"]["handle"]}

    if UserStore.add_user(user) do
      conn
      |> login_user(user)
      |> redirect_to_arena()
    else
      send_resp(conn, 500, "somehow the user already exists")
    end
  end

  def arena(conn, _params) do
    user_id =
      conn
      |> fetch_cookies()
      |> Map.get(:cookies, %{})
      |> Map.get("clicky_id")

    if is_nil(user_id) do
      redirect_to_homepage(conn)
    else
      LiveView.Controller.live_render(
        conn,
        ClickyWeb.CounterView,
        session: %{user_id: user_id, count: Counter.value()}
      )
    end
  end

  defp login_user(conn, %User{} = user) do
    put_resp_cookie(conn, "clicky_id", user.id)
  end

  defp redirect_to_arena(conn), do: redirect(conn, to: "/arena")
  defp redirect_to_homepage(conn), do: redirect(conn, to: "/")

end
