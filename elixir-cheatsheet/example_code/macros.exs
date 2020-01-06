defmodule Macros do

  ~S"""
  # "quote" returns an AST structure from a function call.
  iex(1)> quote do: 10 + 22
  {:+, [context: Elixir, import: Kernel], [10, 22]}

  # "unquote" turns AST in code and can only be called
  # in a "quote" call. (Example turns AST into 10+22 and quote converts
  # it back to AST.)
  iex(1)> quote do
  ...(1)>  unquote({:+, [context: Elixir, import: Kernel], [10, 22]})
  ...(1)> end
  {:+, [context: Elixir, import: Kernel], [10, 22]}

  """

  @doc """
    Macros get AST and returns AST

    Example:
      iex> require MyMacros
      MyMacros
      iex> MyMacros.plus_to_minus 30 + 20
      10
  """
  defmacro plus_to_minus({:+, _context_and_import, [arg1, arg2]} = _an_ast) do
    quote do
      # Without unquote the macro would look for variables called arg1 and arg2
      # in the macro-caller context!
      unquote(arg1) - unquote(arg2)
    end
  end

  ~S"""
  # The basic types return quoted themself.
  iex> quote do: 20
  20

  """

  #
  # var! and macro hygiene
  #

   @doc """
   Macros follow hygiene.

    Example:
      iex(1)> require MyMacros
      MyMacros
      iex(2)> name = "Alice"
      "Alice"
      iex(3)> MyMacros.set_name
      "Bob"
      iex(4)> name
      "Alice"
   """
  defmacro set_name do
    # Unused - macro hygiene will protect the caller context
    quote do
      name = "Bob"
    end
  end

  @doc """
  Use var! with care.

    Example:
      iex(1)> require MyMacros
      MyMacros
      iex(2)> name = "Alice"
      "Alice"
      iex(3)> MyMacros.set_name_with_var
      "Bob"
      iex(4)> name # <--- variable "name" was changed
      "Bob"
  """
  defmacro set_name_with_var do
    # var! removes this protection
    quote do
      var!(name) = "Bob"
    end
  end

  #
  # The module has lots of helpful functions for tinkering around with
  # macros.
  #

  ~S"""
  #
  # Create an AST
  #
  iex> ast = quote do
  ...>    if 3 > 10 do
  ...>       IO.puts "Not possible"
  ...>    end
  ...> end
  {:if, [context: Elixir, import: Kernel],
    [
      {:>, [context: Elixir, import: Kernel], [3, 10]},
      [
        do: {{:., [], [{:__aliases__, [alias: false], [:IO]}, :puts]}, [],
        ["Not possible"]}
      ]
    ]
  }

  #
  # Show me your true face! (aka expand the macro and all macros inside)
  #
  iex> Macro.expand ast, __ENV__
  {:case, [optimize_boolean: true],
   [
     {:>, [context: Elixir, import: Kernel], [3, 10]},
     [
       do: [
         {:->, [],
          [
            [
              {:when, [],
               [
                 {:x, [counter: -576460752303422973], Kernel},
                 {{:., [], [Kernel, :in]}, [],
                  [{:x, [counter: -576460752303422973], Kernel}, [false, nil]]}
               ]}
            ],
            nil
          ]},
         {:->, [],
          [
            [{:_, [], Kernel}],
            {{:., [],
              [
                {:__aliases__, [counter: -576460752303422973, alias: false],
                 [:IO]},
                :puts
              ]}, [], ["Not possible"]}
          ]}
       ]
     ]
   ]
  }

  """
end
