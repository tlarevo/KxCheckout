defmodule KxCheckout.Models.DiscountRules.BuyXGetDiscount do
  defstruct x: nil, type: :price, value: nil, apply_to: :one

  @type t :: %__MODULE__{
          x: integer(),
          type: :price | :fraction,
          value: float(),
          apply_to: :one | :all
        }
  alias __MODULE__
  alias KxCheckout.Protocols.DiscountRule

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
  end
end
