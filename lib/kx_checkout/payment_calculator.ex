defmodule KxCheckout.PaymentCalculator do
  @moduledoc """
  Payment Calculator for KxCheckout ShoppingCart
  """

  @doc """
  Calculate the payment for the given shopping list and discount rules

  This function is designed as pure function and has no side-effects
  it takes inputs and produce output without making any state changes
  outside of its scope

  1. First calculate the total counts of each product/item type
  2. Then calculate the totals cost and total eligible discounts for each product/item type
  3. Finally calculate the net total cost(gorss total), total discount and net total

  ## Examples

    iex> alias KxCheckout.PaymentCalculator
    iex> shopping_list = [{:GR1, 3.11}, {:SR1, 5.00}, {:CF1, 11.23}, {:GR1, 3.11}]
    iex> promotions = %{}
    iex> PaymentCalculator.calculate(shopping_list, promotions)
    {:ok, 22.45}

  """

  alias KxCheckout.Protocols.DiscountRule
  alias KxCheckout.Models.DiscountRules.{BuyXGetY, BuyXGetDiscount}

  @type shopping_list :: [{atom(), float()}]
  @type discount_rules :: %{atom() => BuyXGetY.t() | BuyXGetDiscount.t()}

  @spec calculate(shopping_list(), discount_rules()) :: {:ok, float()}
  def calculate(shopping_list, discount_rules)
      when is_list(shopping_list) and is_map(discount_rules) do
    %{net_total: net_total} =
      shopping_list
      |> calculate_item_counts()
      |> calculate_item_totals_and_discounts(discount_rules)
      |> calculate_net_total()

    {:ok, net_total}
  end

  defp calculate_item_counts(shopping_list) do
    # By reducing the shopping list, create item details map
    # Use Maps update function to populate and update the count simaltaniously
    # Variable p_code stands for product code
    Enum.reduce(shopping_list, %{}, fn {p_code, price}, acc ->
      Map.update(
        acc,
        p_code,
        %{count: 1, price: price, total: price, discount: 0.00},
        fn %{
             count: count
           } = item_details ->
          %{item_details | count: count + 1}
        end
      )
    end)
  end

  defp calculate_item_totals_and_discounts(item_map, discount_rules) do
    Enum.reduce(item_map, item_map, fn {p_code, %{count: count, price: price} = item_details},
                                       acc ->
      # Calculate the disount by first fetching the applicable discount rule for the product code
      # and then passing it to calculating the applicable discount for the given rule
      # There could be either applicable discount or no discount even if there is applicable discount
      # rule for the given product code
      discount =
        Map.get(discount_rules, p_code, %{})
        |> DiscountRule.calculate_discount({count, price})

      # Calculate total by multiplying the count and price of the item
      total = count * price

      # Use short hand map update syntax to update both item map and item details map
      # Choise was made to use short-hand syntax keep the code clean and reduce use of
      # intermediate variables
      %{acc | p_code => %{item_details | discount: discount, total: total}}
    end)
  end

  defp calculate_net_total(item_map) do
    # Calculate both gross total(total cost) and total discount by reducing
    # item totals and discounts in to 2 separate figures
    {gross_total, total_discount} =
      item_map
      |> Enum.reduce({0.00, 0.00}, fn {_k, %{total: total, discount: discount}},
                                      {gross_total, total_discount} ->
        {gross_total + total, total_discount + discount}
      end)

    # Get net total by deducting total discount from gross total(total cost)
    net_total = gross_total - total_discount

    # Build the final map using item details, gross total, total discount and
    # net total also used Float's round function to get around the floating point arithmetic issues
    # Refer https://hexdocs.pm/elixir/1.15.4/Float.html#module-known-issues for details
    %{
      item_details: item_map,
      gross_total: gross_total |> Float.round(2),
      total_discount: total_discount |> Float.round(2),
      net_total: net_total |> Float.round(2)
    }
  end
end
