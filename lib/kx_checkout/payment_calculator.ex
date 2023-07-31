defmodule KxCheckout.PaymentCalculator do
  @moduledoc """
  Payment Calculator for KxCheckout ShoppingCart
  """

  @doc """
  Calculate the payment for the given shopping list and discount rules

  This function is designed as pure function and has no side-effects
  it takes inputs and produce output without making any state changes
  outside of its scope

  ## Examples

    iex> alias KxCheckout.PaymentCalculator
    iex> shopping_list = [{:GR1, 3.11}, {:SR1, 5.00}, {:CF1, 11.23}, {:GR1, 3.11}]
    iex> promotions = %{}
    iex> PaymentCalculator.calculate(shopping_list, promotions)
    {:ok, 22.45}

  """
  @spec calculate(list(tuple()), list()) :: {:ok, float()}
  def calculate(shopping_list, discount_rules) do
    %{net_total: net_total} =
      shopping_list
      |> calculate_item_counts()
      |> calculate_item_totals_and_discounts(discount_rules)
      |> calculate_net_total()

    {:ok, net_total}
  end

  defp calculate_item_counts(shopping_list) do
    Enum.reduce(shopping_list, %{}, fn {code, price}, acc ->
      Map.update(
        acc,
        code,
        %{count: 1, price: price, total: price, discount: 0.00},
        fn %{
             count: count
           } = item ->
          %{item | count: count + 1}
        end
      )
    end)
  end

  defp calculate_item_totals_and_discounts(item_map, discount_rules) do
    Enum.reduce(item_map, item_map, fn {code, %{count: count, price: price} = details}, acc ->
      discount =
        Map.get(discount_rules, code)
        |> calculate_discount_for_rule({count, price})

      total = count * price

      %{acc | code => %{details | discount: discount, total: total}}
    end)
  end

  defp calculate_net_total(item_map) do
    {gross_total, total_discount} =
      item_map
      |> Enum.reduce({0.00, 0.00}, fn {_k, %{total: total, discount: discount}},
                                      {gross_total, total_discount} ->
        {gross_total + total, total_discount + discount}
      end)

    net_total = gross_total - total_discount

    %{
      item_details: item_map,
      gross_total: gross_total |> Float.round(2),
      total_discount: total_discount |> Float.round(2),
      net_total: net_total |> Float.round(2)
    }
  end

  defp calculate_discount_for_rule(nil, _), do: 0.00

  defp calculate_discount_for_rule(
         %{type: :buy_x_get_one, threshold: threshold},
         {count, price}
       ) do
    if count >= threshold + 1, do: price, else: 0.00
  end

  defp calculate_discount_for_rule(
         %{type: :price_discount, threshold: threshold, price: price},
         {count, _}
       ) do
    if count >= threshold, do: count * price, else: 0.00
  end

  defp calculate_discount_for_rule(
         %{type: :fraction_discount, threshold: threshold, fraction: fraction},
         {count, price}
       ) do
    if count >= threshold, do: count * (price * fraction), else: 0.00
  end
end
