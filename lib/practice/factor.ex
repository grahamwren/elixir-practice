defmodule Practice.Factor do
  def parse_int(text) do
    case Integer.parse text do
      {num, _} -> {:ok, num}
      :error   -> raise ArgumentError, message: "Invalid value given: #{text}"
    end
  end

  def factor(x) do factor(x, 2) end

  def factor(x, n) when n * n <= x do
    case rem x, n do
      0 -> [n | factor(div(x, n), 2)]
      _ -> factor(x, n + 1)
    end
  end

  def factor(x, _n) do [x] end
end