# ---
# Unit tests for Payment Calculator
# ---
defmodule KxCheckout.ShoppingCart.PaymentCalculatorTest do
  use ExUnit.Case
  doctest KxCheckout.ShoppingCart.PaymentCalculator
  alias KxCheckout.ShoppingCart.PaymentCalculator

  describe "calculate/2" do
    test "success: given list of shopping items details and with no promotions applied" do
      shopping_list = [{:GR1, 3.11}, {:SR1, 5.00}, {:CF1, 11.23}]
      promotions = []
      assert({:ok, 19.34} = PaymentCalculator.calculate(shopping_list, promotions))
    end
  end
end
