defmodule KxCheckout do
  @moduledoc """
  `KxCheckout` is shopping bill calculater with dynamic discount rules
  """

  # Aliases
  alias KxCheckout.Models.ShoppingBill
  alias KxCheckout.Models.Product
  alias KxCheckout.PaymentCalculator
  alias KxCheckout.Behaviours.Repo

  # Type defitions
  @type shopping_item_codes :: [atom()]

  @doc """
  Provided list of shopping items prepare the shopping bill consider the discount rules

  ## Examples

    iex> alias KxCheckout.Models.Product
    iex> alias KxCheckout.Models.DiscountRules.{BuyXGetY, BuyXGetDiscount}
    iex> products = %{
    ...>   :GR1 => %Product{product_code: :GR1, name: "Green tea", price: 3.11, stock: 100},
    ...>   :SR1 => %Product{product_code: :SR1, name: "Strawberries", price: 5.00, stock: 100},
    ...>   :CF1 => %Product{product_code: :CF1, name: "Coffee", price: 11.23, stock: 100}
    ...> }
    iex> discounts = %{
    ...>   :GR1 => %BuyXGetY{x: 1, y: 1},
    ...>   :SR1 => %BuyXGetDiscount{x: 3, type: :price, value: 0.50, apply_to: :all},
    ...>   :CF1 => %BuyXGetDiscount{x: 3, type: :fraction, value: 1 / 3, apply_to: :all}
    ...> }
    iex> alias KxCheckout.FakeInventoryRepo
    iex> FakeInventoryRepo.start_link(%{products: products, discount_rules: discounts})
    iex> shopping_bill = KxCheckout.prepare_bill([:GR1, :SR1, :GR1, :GR1, :CF1], FakeInventoryRepo)
    iex> KxCheckout.get_net_total(shopping_bill)
    22.45

  """

  @spec prepare_bill(shopping_item_codes(), Repo) :: ShoppingBill.t()
  def prepare_bill(shopping_item_codes, repo) do
    items_with_price = get_items_with_price(shopping_item_codes, repo)
    discount_rules = repo.all(:discount_rules)

    PaymentCalculator.calculate(items_with_price, discount_rules)
  end

  @spec get_net_total(ShoppingBill.t()) :: float()
  def get_net_total(%ShoppingBill{net_total: net_total}), do: net_total

  defp get_items_with_price(item_codes, repo) do
    item_codes
    |> Enum.reduce([], fn code, acc ->
      %Product{price: price} = repo.get(:products, code)
      [{code, price} | acc]
    end)
  end
end
