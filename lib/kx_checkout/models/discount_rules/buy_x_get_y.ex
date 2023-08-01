defmodule KxCheckout.Models.DiscountRules.BuyXGetY do
  @moduledoc """
  This is a configurable rule that can be configured as follows;
  When customer buys X number of items of same product, Y number of item(s) is/are free
  using `threshold` number of items(X) of the product that needs to in the
  cart can be configured

  ## Examples
    iex> alias KxCheckout.Protocols.DiscountRule
    iex> alias KxCheckout.Models.DiscountRules.BuyXGetY
    iex> rule = %BuyXGetY{x: 1, y: 1}
    iex> DiscountRule.calculate_discount(rule, {2, 1.00})
    1.00

  """

  defstruct x: 1, y: 1
  @type t :: %__MODULE__{x: integer(), y: integer()}
  alias __MODULE__
  alias KxCheckout.Protocols.DiscountRule

  defmodule InvalidRuleArugumentsError do
    defexception message: "x value can not be less than y"
  end

  defimpl DiscountRule do
    @doc """
      This function accepts 2 inputs;
      "x" number of same items that needs to be purchased to become eligible for the discount and the
      "y" number of items that discount would be applied to
      hence the name rule name BuyXGetY
    """
    def calculate_discount(
          %BuyXGetY{x: x, y: y},
          {count, price}
        ) do
      if x < y, do: raise(InvalidRuleArugumentsError)
      if count >= x + y, do: y * price, else: 0.00
    end
  end
end
