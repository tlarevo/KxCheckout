defmodule KxCheckoutTest do
  use ExUnit.Case
  doctest KxCheckout
  alias KxCheckout.Models.Product
  alias KxCheckout.Models.DiscountRules.{BuyXGetY, BuyXGetDiscount}
  alias KxCheckout.Inventory

  setup_all do
    products = %{
      :GR1 => %Product{product_code: :GR1, name: "Green tea", price: 3.11, stock: 100},
      :SR1 => %Product{product_code: :SR1, name: "Strawberries", price: 5.00, stock: 100},
      :CF1 => %Product{product_code: :CF1, name: "Coffee", price: 11.23, stock: 100}
    }

    discounts = %{
      :GR1 => %BuyXGetY{x: 1, y: 1},
      :SR1 => %BuyXGetDiscount{x: 3, type: :price, value: 0.50, apply_to: :all},
      :CF1 => %BuyXGetDiscount{x: 3, type: :fraction, value: 1 / 3, apply_to: :all}
    }

    Inventory.start_link(%{products: products, discount_rules: discounts})
    %{repo: Inventory}
  end

  describe "prepare_bill/2" do
    test "success: given shopping list GR1,SR1,GR1,GR1,CF1 total bill is 22.45", %{repo: repo} do
      shopping_list = [:GR1, :SR1, :GR1, :GR1, :CF1]
      assert 22.45 == KxCheckout.prepare_bill(shopping_list, repo) |> KxCheckout.get_net_total()
    end

    test "success: given shopping list GR1, GR1 total bill is 3.11", %{repo: repo} do
      shopping_list = [:GR1, :GR1]
      assert 3.11 == KxCheckout.prepare_bill(shopping_list, repo) |> KxCheckout.get_net_total()
    end

    test "success: given shopping list SR1,SR1,GR1,SR1 total bill is 16.61", %{repo: repo} do
      shopping_list = [:SR1, :SR1, :GR1, :SR1]
      assert 16.61 == KxCheckout.prepare_bill(shopping_list, repo) |> KxCheckout.get_net_total()
    end

    test "success: given shopping list GR1,CF1,SR1,CF1,CF1 total bill is 30.57", %{repo: repo} do
      shopping_list = [:GR1, :CF1, :SR1, :CF1, :CF1]
      assert 30.57 == KxCheckout.prepare_bill(shopping_list, repo) |> KxCheckout.get_net_total()
    end
  end
end
