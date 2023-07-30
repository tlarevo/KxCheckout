defmodule KxCheckout.ShoppingCart.PaymentCalculator do
  @moduledoc """
  Payment Calculator for KxCheckout ShoppingCart
  """

  @doc """
  Calculate the payment for the given shopping list and promotions

  ## Examples

    iex> alias KxCheckout.ShoppingCart.PaymentCalculator
    iex> shopping_list = [{:GR1, 3.11}, {:SR1, 5.00}, {:CF1, 11.23}]
    iex> promotions = []
    iex> PaymentCalculator.calculate(shopping_list, promotions)
    {:ok, 19.34}

  """
  @spec calculate(list(tuple()), list()) :: {:ok, float()}
  def calculate(_shopping_list, _promotions) do
    :not_implemented
  end
end
