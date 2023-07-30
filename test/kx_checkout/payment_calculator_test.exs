# ---
# Unit tests for Payment Calculator
# ---
defmodule KxCheckout.PaymentCalculatorTest do
  use ExUnit.Case
  doctest KxCheckout.PaymentCalculator
  alias KxCheckout.PaymentCalculator

  describe "calculate/2" do
    test "success: given list of shopping items details and with no promotions applied" do
      shopping_list = [{:GR1, 3.11}, {:SR1, 5.00}, {:CF1, 11.23}, {:GR1, 3.11}]
      promotions = []
      assert({:ok, 22.45} = PaymentCalculator.calculate(shopping_list, promotions))
    end
  end
end
