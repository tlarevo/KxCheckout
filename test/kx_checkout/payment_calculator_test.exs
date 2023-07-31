# ---
# Unit tests for Payment Calculator
# ---
defmodule KxCheckout.PaymentCalculatorTest do
  use ExUnit.Case
  doctest KxCheckout.PaymentCalculator
  alias KxCheckout.PaymentCalculator
  alias KxCheckout.Models.DiscountRules.{BuyXGetY, BuyXGetDiscount}

  setup_all do
    # discounts = %{
    #   :GR1 => %{type: :buy_x_get_one, threshold: 1},
    #   :SR1 => %{type: :price_discount, threshold: 3, price: 0.50},
    #   :CF1 => %{type: :fraction_discount, threshold: 3, fraction: 1 / 3}
    # }

    discounts = %{
      :GR1 => %BuyXGetY{x: 1, y: 1},
      :SR1 => %BuyXGetDiscount{x: 3, type: :price, value: 0.50, apply_to: :all},
      :CF1 => %BuyXGetDiscount{x: 3, type: :fraction, value: 1 / 3, apply_to: :all}
    }

    %{discounts: discounts}
  end

  describe "calculate/2" do
    test "success: given shopping items; GR1,SR1,GR1,GR1,CF1", %{discounts: _} do
      shopping_list = [{:GR1, 3.11}, {:SR1, 5.00}, {:CF1, 11.23}, {:GR1, 3.11}]
      discounts = %{}
      assert({:ok, 22.45} = PaymentCalculator.calculate(shopping_list, discounts))
    end

    test "success: given shopping item list; GR1,SR1,GR1,GR1,CF1", %{discounts: discounts} do
      shopping_list = [
        {:GR1, 3.11},
        {:SR1, 5.00},
        {:GR1, 3.11},
        {:GR1, 3.11},
        {:CF1, 11.23}
      ]

      assert({:ok, 22.45} = PaymentCalculator.calculate(shopping_list, discounts))
    end
  end

  test "success: given shopping items; GR1, GR1", %{discounts: discounts} do
    shopping_list = [
      {:GR1, 3.11},
      {:GR1, 3.11}
    ]

    assert({:ok, 3.11} = PaymentCalculator.calculate(shopping_list, discounts))
  end

  test "success: given shopping items; SR1,SR1,GR1,SR1", %{discounts: discounts} do
    shopping_list = [
      {:SR1, 5.00},
      {:SR1, 5.00},
      {:GR1, 3.11},
      {:SR1, 5.00}
    ]

    assert({:ok, 16.61} = PaymentCalculator.calculate(shopping_list, discounts))
  end

  test "success: given shopping items; GR1,CF1,SR1,CF1,CF1", %{discounts: discounts} do
    shopping_list = [
      {:GR1, 3.11},
      {:CF1, 11.23},
      {:SR1, 5.00},
      {:CF1, 11.23},
      {:CF1, 11.23}
    ]

    assert({:ok, 30.57} = PaymentCalculator.calculate(shopping_list, discounts))
  end
end
