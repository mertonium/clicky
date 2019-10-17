defmodule Clicky.UserStore do
  use GenServer
  alias Clicky.User

  @table :users

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_) do
    :ets.new(@table, [:set, :named_table, :public])
    {:ok, %{}}
  end

  def add_user(%User{} = user) do
    case :ets.lookup(@table, user.id) do
      [] ->
        :ets.insert(@table, {user.id, user.handle})
      _ ->
        false
    end
  end

  def fetch_user(uid) do
    case :ets.lookup(@table, uid) do
      [{^uid, handle}] ->
        {:ok, handle}
      _ ->
        {:error, "User not found"}
    end
  end
end
