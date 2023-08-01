defmodule KxCheckout.Inventory do
  use Agent

  @moduledoc """
  Using agent as a stand in DB
  """
  def start_link(%{products: _products, discount_rules: _rules} = data) do
    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  def get(:products, key) do
    Agent.get(__MODULE__, fn %{products: products} -> Map.get(products, key, %{}) end)
  end

  def get(:discount_rules, key) do
    Agent.get(__MODULE__, fn %{discount_rules: rules} -> Map.get(rules, key, %{}) end)
  end

  def get_all(:discount_rules) do
    Agent.get(__MODULE__, fn %{discount_rules: rules} -> rules end)
  end
end
