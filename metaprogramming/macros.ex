defmodule Unless do
  # Unless representation with functions
  def unless_fun(clause, do: expression) do
    if(!clause, do: expression)
  end

  # Unless representation with macros
  defmacro unless_macro(clause, do: expression) do
    quote do
      if(!unquote(clause), do: unquote(expression))
    end
  end
end

defmodule Hygiene do
  defmacro no_interference do
    quote do: a = 1
  end

  defmacro interference do
    quote do: var!(a) = 1
  end
end

defmodule HygieneTest do
  def go do
    require Hygiene
    a = 13
    Hygiene.no_interference()
    IO.puts("This has no interference #{a}")

    # This has a warning cause this value is never used
    a = 13
    Hygiene.interference()
    IO.puts("This has interferenece #{a}")
  end
end

defmodule Sample do
  defmacrop sum(a, b) do
    quote do
      unquote(a + b)
    end
  end

  def multi do
    sum(1, 3)
  end

  # This throw an error cause the macro should be defined before its usage
  # defmacrop sum(a, b) do
  #   quote do
  #     unquote(a + b)
  #   end
  # end

  # creating variables with the Macro.var/2
  defmacro initialize_to_char_count(variables) do
    Enum.map(variables, fn name ->
      var = Macro.var(name, nil)
      length = name |> Atom.to_string() |> String.length()

      quote do
        unquote(var) = unquote(length)
      end
    end)
  end

  def run do
    initialize_to_char_count([:red, :green, :yellow])
    [red, green, yellow]
  end
end
