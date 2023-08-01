# KxCheckout

KxCheckout is a supermarket checkout system implemented following TDD and using Elixir

## Setup

### Optional

Erlang and Elixir need to be installed, install them using `brew` or `asdf`

```bash
# Using brew
brew install erlang elixir

# Using asdf
# Install Erlang
asdf add plugin erlang
asdf install erlang latest
asdf global erlang latest

# Install Elixir
asdf add plugin elixir
asdf install elixir latest
asdf global elixir latest

```

### Clone & Test

```bash
# first clone the project
git clone https://github.com/tlarevo/KxCheckout.git

# update the deps
mix deps.get

# then run mix test
mix test

```

### For Review

For tests check:

- `test/kx_checkout_test.exs`
- `test/kx_checkout/payment_calculator_test.exs`
- `test/kx_checkout/models/discount_rules/buy_x_get_y_test.ex`
- `test/kx_checkout/models/discount_rules/buy_x_get_discount_test.ex`

For logic implementation check:

- `lib/kx_checkout.ex`
- `lib/kx_checkout/payment_calculator.ex`
- `lib/kx_checkout/models/discount_rules/buy_x_get_y.ex`
- `lib/kx_checkout/models/discount_rules/buy_x_get_discount.ex`

## Use as a Library

Add following to `mix.exs` under `deps`

```elixir
def deps do
  [
    {:kx_checkout, git: "https://github.com/tlarevo/KxCheckout.git", brance: :master}
  ]
end
```
