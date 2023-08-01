defmodule KxCheckout.Models.DiscountRules.BuyXGetYTest do
  use ExUnit.Case

  doctest KxCheckout.Models.DiscountRules.BuyXGetY
  alias KxCheckout.Protocols.DiscountRule
  alias KxCheckout.Models.DiscountRules.BuyXGetY
  alias KxCheckout.Models.DiscountRules.BuyXGetY.InvalidRuleArugumentsError

  describe "calculate_discount/2" do
    test "success: given x: 1, y: 1 and count: 2, price: 1.00 returns discount as 1.00" do
      rule = %BuyXGetY{x: 1, y: 1}
      assert 1.00 == DiscountRule.calculate_discount(rule, {2, 1.00})
    end

    test "success: given x: 3, y: 2 and count: 5, price: 2.00 returns discount as 4.00" do
      rule = %BuyXGetY{x: 3, y: 2}
      assert 4.00 == DiscountRule.calculate_discount(rule, {5, 2.00})
    end

    test "success: given x: 3, y: 1 and count: 3, price: 2.00 returns discount as 0.00" do
      rule = %BuyXGetY{x: 3, y: 1}
      assert 0.00 == DiscountRule.calculate_discount(rule, {3, 2.00})
    end

    test "success: given x: 3, y: 2 and count: 7, price: 2.00 returns discount as 4.00" do
      rule = %BuyXGetY{x: 3, y: 2}
      assert 4.00 == DiscountRule.calculate_discount(rule, {7, 2.00})
    end

    test "failiure: given x: 3, y: 4 raise an Error" do
      rule = %BuyXGetY{x: 3, y: 4}

      assert_raise(InvalidRuleArugumentsError, fn ->
        DiscountRule.calculate_discount(rule, {7, 3.00})
      end)
    end
  end
end
