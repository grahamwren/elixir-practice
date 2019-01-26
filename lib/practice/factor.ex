defmodule Practice.Factor do
  def parse_int(text) do
    case Integer.parse text do
      {num, _} -> {:ok, num}
      :error   -> raise ArgumentError, message: "Invalid value given: #{text}"
    end
  end

  def factor(x), do: factor(x, 2)

  def factor(x, n) when n * n <= x do
    case rem x, n do
      0 -> [n | factor(div(x, n), n)]
      _ -> factor(x, n + 1)
    end
  end

  def factor(x, _), do: [x]
end