defmodule KxCheckout.Models.DiscountRules.BuyXGetDiscountTest do
  use ExUnit.Case
  doctest(KxCheckout.Models.DiscountRules.BuyXGetDiscount)
  alias KxCheckout.Models.DiscountRules.BuyXGetDiscount.InvalidRuleArugumentsError
  alias KxCheckout.Protocols.DiscountRule
  alias KxCheckout.Models.DiscountRules.BuyXGetDiscount

  describe "calculate_discount/2" do
    test "success: given rule x: 3, type: :price, value: 0.50, apply_to: :all and count: 3, price: 1.00 returns discount as 1.50" do
      rule = %BuyXGetDiscount{x: 3, type: :price, value: 0.50, apply_to: :all}
      assert 1.50 == DiscountRule.calculate_discount(rule, {3, 1.00})
    end

    test "success: given rule x: 3, type: :price, value: 0.50, apply_to: :all and count: 2, price: 1.00 returns discount as 1.50" do
      rule = %BuyXGetDiscount{x: 3, type: :price, value: 0.50, apply_to: :all}
      assert 0.00 == DiscountRule.calculate_discount(rule, {2, 1.00})
    end

    test "success: given rule x: 3, type: :faction, value: 1 / 2, apply_to: :all and count: 3, price: 1.00 returns discount as 1.50" do
      rule = %BuyXGetDiscount{x: 3, type: :fraction, value: 1 / 2, apply_to: :all}
      assert 1.50 == DiscountRule.calculate_discount(rule, {3, 1.00})
    end

    test "success: given rule x: 3, type: :price, value: 0.50, apply_to: :one and count: 2, price: 1.00 returns discount as 1.50" do
      rule = %BuyXGetDiscount{x: 3, type: :price, value: 0.50, apply_to: :one}
      assert 0.50 == DiscountRule.calculate_discount(rule, {3, 1.00})
    end

    test "success: given rule x: 3, type: :fraction, value: 1 / 2, apply_to: :one and count: 2, price: 1.00 returns discount as 1.50" do
      rule = %BuyXGetDiscount{x: 3, type: :fraction, value: 1 / 2, apply_to: :one}
      assert 0.50 == DiscountRule.calculate_discount(rule, {3, 1.00})
    end

    test "failure: given rule x: 3, type: :faction, value: 1 / 2, apply_to: :one and count: 2, price: 1.00 raises Error" do
      rule = %BuyXGetDiscount{x: 3, type: :faction, value: 1 / 2, apply_to: :one}

      assert_raise(InvalidRuleArugumentsError, fn ->
        DiscountRule.calculate_discount(rule, {3, 1.00})
      end)
    end

    test "failure: given rule x: 3, type: :fraction, value: 1 / 2, apply_to: :neo and count: 2, price: 1.00, raises Error" do
      rule = %BuyXGetDiscount{x: 3, type: :fraction, value: 1 / 2, apply_to: :neo}

      assert_raise(InvalidRuleArugumentsError, fn ->
        DiscountRule.calculate_discount(rule, {3, 1.00})
      end)
    end
  end
end
