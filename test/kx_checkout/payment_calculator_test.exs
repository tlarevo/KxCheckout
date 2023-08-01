# ---
# Unit tests for Payment Calculator
# ---
defmodule KxCheckout.PaymentCalculatorTest do
  use ExUnit.Case
  doctest KxCheckout.PaymentCalculator
  alias KxCheckout.PaymentCalculator
  alias KxCheckout.Models.ShoppingBill
  alias KxCheckout.Models.DiscountRules.{BuyXGetY, BuyXGetDiscount}

  setup_all do
    discounts = %{
      :GR1 => %BuyXGetY{x: 1, y: 1},
      :SR1 => %BuyXGetDiscount{x: 3, type: :price, value: 0.50, apply_to: :all},
      :CF1 => %BuyXGetDiscount{x: 3, type: :fraction, value: 1 / 3, apply_to: :all}
    }

    %{discounts: discounts}
  end

  describe "calculate/2" do
    test "success: given shopping items; GR1,SR1,GR1,GR1,CF1 returns net total: 22.45", %{
      discounts: _
    } do
      shopping_list = [{:GR1, 3.11}, {:SR1, 5.00}, {:CF1, 11.23}, {:GR1, 3.11}]
      discounts = %{}

      assert(
        %ShoppingBill{net_total: 22.45} = PaymentCalculator.calculate(shopping_list, discounts)
      )
    end

    test "success: given shopping item list; GR1,SR1,GR1,GR1,CF1 returns net total: 22.45", %{
      discounts: discounts
    } do
      shopping_list = [
        {:GR1, 3.11},
        {:SR1, 5.00},
        {:GR1, 3.11},
        {:GR1, 3.11},
        {:CF1, 11.23}
      ]

      assert(
        %ShoppingBill{net_total: 22.45} = PaymentCalculator.calculate(shopping_list, discounts)
      )
    end
  end

  test "success: given shopping items; GR1, GR1 returns net total as 3.11", %{
    discounts: discounts
  } do
    shopping_list = [
      {:GR1, 3.11},
      {:GR1, 3.11}
    ]

    assert(%ShoppingBill{net_total: 3.11} = PaymentCalculator.calculate(shopping_list, discounts))
  end

  test "success: given shopping items; SR1,SR1,GR1,SR1 returns net total as 16.61", %{
    discounts: discounts
  } do
    shopping_list = [
      {:SR1, 5.00},
      {:SR1, 5.00},
      {:GR1, 3.11},
      {:SR1, 5.00}
    ]

    assert(
      %ShoppingBill{net_total: 16.61} = PaymentCalculator.calculate(shopping_list, discounts)
    )
  end

  test "success: given shopping items; GR1,CF1,SR1,CF1,CF1 returns net total as 30.57", %{
    discounts: discounts
  } do
    shopping_list = [
      {:GR1, 3.11},
      {:CF1, 11.23},
      {:SR1, 5.00},
      {:CF1, 11.23},
      {:CF1, 11.23}
    ]

    assert(
      %ShoppingBill{net_total: 30.57} = PaymentCalculator.calculate(shopping_list, discounts)
    )
  end
end
