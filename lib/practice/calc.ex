defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    expr
    |> String.split ~r/\s+/
    |> tag_tokens
    |> eval []
  end

  def tag_tokens(list) do
    case hd list do
      "*" -> [{:op, "*"} | tag_tokens tl(list)]
      "/" -> [{:op, "/"} | tag_tokens tl(list)]
      "+" -> [{:op, "+"} | tag_tokens tl(list)]
      "-" -> [{:op, "-"} | tag_tokens tl(list)]
      num -> [{:num, num} | tag_tokens tl(list)]
    end
  end

  def eval(list, stack) when hd list = {:op, op} do
  end

  def eval(list, stack) when hd list = {:num, num} do
  end
end
