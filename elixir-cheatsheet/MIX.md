![Elixir](https://elixir-lang.org/images/logo/logo.png)

# Cheatsheet - Mix

## Phoenix mix tasks

For translations
```sh
# Searches for gettext msgid add them to POT
mix gettext.extract

# Copys missing msgid from POT to PO
mix gettext.merge priv/gettext
```
