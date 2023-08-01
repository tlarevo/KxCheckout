defmodule KxCheckout.Models.DiscountRules.BuyXGetDiscount do
  @moduledoc """
  This is a configurable rule that can be configured as follows;
  When customer buys X number of items of same product, cutomer become
  eligible for a price discount(0.50) or fractional discount(1/3) of
  original price

  ## Examples
    iex> alias KxCheckout.Protocols.DiscountRule
    iex> alias KxCheckout.Models.DiscountRules.BuyXGetDiscount
    iex> rule = %BuyXGetDiscount{x: 3, type: :price, value: 0.50, apply_to: :all}
    iex> DiscountRule.calculate_discount(rule, {3, 1.00})
    1.50

  """
  defstruct x: nil, type: :price, value: nil, apply_to: :one

  @type t :: %__MODULE__{
          x: integer(),
          type: :price | :fraction,
          value: float(),
          apply_to: :one | :all
        }
  alias __MODULE__
  alias KxCheckout.Protocols.DiscountRule

  defmodule InvalidRuleArugumentsError do
    defexception message: "Acceptable values for type is :price or :fraction only"
  end

  defimpl DiscountRule do
    def calculate_discount(
          %BuyXGetDiscount{
            x: x,
            type: :price,
            value: value,
            apply_to: :all
          },
          {count, _}
        ) do
      if count >= x, do: count * value, else: 0.00
    end

    def calculate_discount(
          %BuyXGetDiscount{
            x: x,
            type: :fraction,
            value: value,
            apply_to: :all
          },
          {count, price}
        ) do
      if count >= x, do: count * (price * value), else: 0.00
    end

    def calculate_discount(
          %BuyXGetDiscount{
            x: x,
            type: :price,
            value: value,
            apply_to: :one
          },
          {count, _}
        ) do
      if count >= x, do: value, else: 0.00
    end

    def calculate_discount(
          %BuyXGetDiscount{
            x: x,
            type: :fraction,
            value: value,
            apply_to: :one
          },
          {count, price}
        ) do
      if count >= x, do: price * value, else: 0.00
    end

    def calculate_discount(
          %BuyXGetDiscount{
            x: _,
            type: type,
            value: _,
            apply_to: _
          },
          {_, _}
        )
        when type not in [:price, :fraction],
        do: raise(InvalidRuleArugumentsError)

    def calculate_discount(
          %BuyXGetDiscount{
            x: _,
            type: _,
            value: _,
            apply_to: apply_to
          },
          {_, _}
        )
        when apply_to not in [:one, :all],
        do: raise(InvalidRuleArugumentsError)
  end
end
