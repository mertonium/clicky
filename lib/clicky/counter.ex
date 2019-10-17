defmodule Clicky.Counter do
  use GenServer

  @table :counter_tab

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def value do
    [{"total", count}] = :ets.lookup(@table, "total")
    count
  end

  def user_counts do
    @table
    |> :ets.tab2list()
    |> Enum.into(%{})
    |> Map.delete("total")
  end

  def increment(user_id) do
    :ets.update_counter(@table, user_id, {2, 1}, {user_id, 0})
    increment()
  end

  def increment do
    :ets.update_counter(@table, "total", {2, 1}, {"total", 0})
  end

  def show_table, do: :ets.tab2list(@table)

  def init(initial_value) do
    :ets.new(@table, [:set, :named_table, :public])
    :ets.insert(@table, {"total", initial_value})
    {:ok, %{}}
  end
end
