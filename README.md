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

## Use as a Library

Add following to `mix.exs` under `deps`

```elixir
def deps do
  [
    {:kx_checkout, git: "https://github.com/tlarevo/KxCheckout.git", brance: :master}
  ]
end
```
