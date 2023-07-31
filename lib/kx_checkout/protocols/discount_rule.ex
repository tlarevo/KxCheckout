defprotocol KxCheckout.Protocols.DiscountRule do
  def calculate_discount(rule, values)
end

defimpl KxCheckout.Protocols.DiscountRule, for: Any do
  def calculate_discount(_, _), do: 0.00
end

# In case there is no matching discount rule
# Map.get returns %{} (the default value) return 0.00 as discount
defimpl KxCheckout.Protocols.DiscountRule, for: Map do
  def calculate_discount(_, _), do: 0.00
end
