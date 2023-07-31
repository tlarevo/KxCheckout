defmodule KxCheckout.Models.DiscountRules.BuyXGetY do
  @moduledoc """
   This is a configurable rule that can be configured
   as when customer buys X number of items of same product, Y number of item(s) is/are free
   using `threshold` number of items(X) of the product that needs to in the
   cart can be configured
  """
  defstruct x: 1, y: 1
  @type t :: %__MODULE__{x: integer(), y: integer()}
  alias __MODULE__
  alias KxCheckout.Protocols.DiscountRule

  defimpl DiscountRule do
    def calculate_discount(
          %BuyXGetY{x: x, y: y},
          {count, price}
        ) do
      if count >= x + y, do: price, else: 0.00
    end
  end
end
