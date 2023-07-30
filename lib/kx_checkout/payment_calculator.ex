defmodule KxCheckout.PaymentCalculator do
  @moduledoc """
  Payment Calculator for KxCheckout ShoppingCart
  """

  @doc """
  Calculate the payment for the given shopping list and promotions

  ## Examples

    iex> alias KxCheckout.PaymentCalculator
    iex> shopping_list = [{:GR1, 3.11}, {:SR1, 5.00}, {:CF1, 11.23}, {:GR1, 3.11}]
    iex> promotions = []
    iex> PaymentCalculator.calculate(shopping_list, promotions)
    {:ok, 22.45}

  """
  @spec calculate(list(tuple()), list()) :: {:ok, float()}
  def calculate(shopping_list, _promotions) do
    total =
      shopping_list
      |> count_items_by_prod_code()
      |> calculate_total()

    {:ok, total}
  end

  defp count_items_by_prod_code(shopping_list) do
    Enum.reduce(shopping_list, %{}, fn {code, price}, acc ->
      Map.update(acc, code, %{count: 1, price: price}, fn item ->
        %{item | count: item.count + 1, price: item.price}
      end)
    end)
  end

  defp calculate_total(item_counts_with_price) do
    item_counts_with_price
    |> Enum.reduce(0.00, fn {_k, %{count: count, price: price}}, acc ->
      count * price + acc
    end)
  end
end
