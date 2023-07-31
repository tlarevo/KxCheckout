# ---
# Unit tests for Payment Calculator
# ---
defmodule KxCheckout.PaymentCalculatorTest do
  use ExUnit.Case
  doctest KxCheckout.PaymentCalculator
  alias KxCheckout.PaymentCalculator

  describe "calculate/2" do
    test "success: given shopping items; GR1,SR1,GR1,GR1,CF1" do
      shopping_list = [{:GR1, 3.11}, {:SR1, 5.00}, {:CF1, 11.23}, {:GR1, 3.11}]
      discounts = %{}
      assert({:ok, 22.45} = PaymentCalculator.calculate(shopping_list, discounts))
    end

    test "success: given shopping item list; GR1,SR1,GR1,GR1,CF1" do
      shopping_list = [
        {:GR1, 3.11},
        {:SR1, 5.00},
        {:GR1, 3.11},
        {:GR1, 3.11},
        {:CF1, 11.23}
      ]

      discounts = %{
        :GR1 => %{type: :buy_x_get_one, threshold: 1},
        :SR1 => %{type: :price_discount, threshold: 3, price: 0.50},
        :CF1 => %{type: :fraction_discount, threshold: 3, fraction: 1 / 3}
      }

      assert({:ok, 22.45} = PaymentCalculator.calculate(shopping_list, discounts))
    end
  end

  test "success: given shopping items; GR1, GR1" do
    shopping_list = [
      {:GR1, 3.11},
      {:GR1, 3.11}
    ]

    discounts = %{
      :GR1 => %{type: :buy_x_get_one, threshold: 1},
      :SR1 => %{type: :price_discount, threshold: 3, price: 0.50},
      :CF1 => %{type: :fraction_discount, threshold: 3, fraction: 1 / 3}
    }

    assert({:ok, 3.11} = PaymentCalculator.calculate(shopping_list, discounts))
  end

  test "success: given shopping items; SR1,SR1,GR1,SR1" do
    shopping_list = [
      {:SR1, 5.00},
      {:SR1, 5.00},
      {:GR1, 3.11},
      {:SR1, 5.00}
    ]

    discounts = %{
      :GR1 => %{type: :buy_x_get_one, threshold: 1},
      :SR1 => %{type: :price_discount, threshold: 3, price: 0.50},
      :CF1 => %{type: :fraction_discount, threshold: 3, fraction: 1 / 3}
    }

    assert({:ok, 16.61} = PaymentCalculator.calculate(shopping_list, discounts))
  end

  test "success: given shopping items; GR1,CF1,SR1,CF1,CF1" do
    shopping_list = [
      {:GR1, 3.11},
      {:CF1, 11.23},
      {:SR1, 5.00},
      {:CF1, 11.23},
      {:CF1, 11.23}
    ]

    discounts = %{
      :GR1 => %{type: :buy_x_get_one, threshold: 1},
      :SR1 => %{type: :price_discount, threshold: 3, price: 0.50},
      :CF1 => %{type: :fraction_discount, threshold: 3, fraction: 1 / 3}
    }

    assert({:ok, 30.57} = PaymentCalculator.calculate(shopping_list, discounts))
  end
end
