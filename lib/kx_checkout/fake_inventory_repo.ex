defmodule KxCheckout.FakeInventoryRepo do
  use Agent
  alias KxCheckout.Behaviours.Repo
  @behaviour Repo

  @moduledoc """
  Using agent as a stand in DB
  """
  def start_link(%{products: _products, discount_rules: _rules} = data) do
    Agent.start_link(fn -> data end, name: __MODULE__)
  end

  @impl Repo
  def insert(:products, key, value) do
    Agent.update(__MODULE__, fn %{products: products} = data ->
      %{data | products: Map.put(products, key, value)}
    end)
  end

  def insert(:discount_rules, key, value) do
    Agent.update(__MODULE__, fn %{discount_rules: rules} = data ->
      %{data | products: Map.put(rules, key, value)}
    end)
  end

  @impl Repo
  def get(:products, key) do
    Agent.get(__MODULE__, fn %{products: products} -> Map.get(products, key, %{}) end)
  end

  def get(:discount_rules, key) do
    Agent.get(__MODULE__, fn %{discount_rules: rules} -> Map.get(rules, key, %{}) end)
  end

  @impl Repo
  def all(:products) do
    Agent.get(__MODULE__, fn %{products: products} -> products end)
  end

  def all(:discount_rules) do
    Agent.get(__MODULE__, fn %{discount_rules: rules} -> rules end)
  end

  @impl Repo
  def update(:products, key, value) do
    Agent.update(__MODULE__, fn %{products: products} = data ->
      %{data | products: %{products | key => value}}
    end)
  end

  def update(:discount_rules, key, value) do
    Agent.update(__MODULE__, fn %{discount_rules: rules} = data ->
      %{data | discount_rules: %{rules | key => value}}
    end)
  end
end
