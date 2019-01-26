defmodule Practice.Calc do
  @moduledoc """
  Based on the Shunting Yard Algorithm by Edgar Dijkstra from https://www.geeksforgeeks.org/expression-evaluation/
  Steps commented out with "#" are not implemented

  1. While there are still tokens to be read in,
     1.1 Get the next token.
     1.2 If the token is:
         1.2.1 A number: push it onto the value stack.
         # 1.2.2 A variable: get its value, and push onto the value stack.
         # 1.2.3 A left parenthesis: push it onto the operator stack.
         # 1.2.4 A right parenthesis:
         #   1 While the thing on top of the operator stack is not a
         #     left parenthesis,
         #       1 Pop the operator from the operator stack.
         #       2 Pop the value stack twice, getting two operands.
         #       3 Apply the operator to the operands, in the correct order.
         #       4 Push the result onto the value stack.
         #   2 Pop the left parenthesis from the operator stack, and discard it.
         1.2.5 An operator (call it this_op):
           1 While the operator stack is not empty, and the top thing on the
             operator stack has the same or greater precedence as this_op,
             1 Pop the operator from the operator stack.
             2 Pop the value stack twice, getting two operands.
             3 Apply the operator to the operands, in the correct order.
             4 Push the result onto the value stack.
           2 Push this_op onto the operator stack.
  2. While the operator stack is not empty,
      1 Pop the operator from the operator stack.
      2 Pop the value stack twice, getting two operands.
      3 Apply the operator to the operands, in the correct order.
      4 Push the result onto the value stack.
  3. At this point the operator stack should be empty, and the value
     stack should have only one value in it, which is the final result.
  """

  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  @operator_precedence "-+/*"
  def precedence(op) do
    {i, _} = :binary.match @operator_precedence, op
    i
  end

  def apply_op(op, first_arg, second_arg) do
    case op do
      "*" -> second_arg * first_arg
      "/" -> second_arg / first_arg
      "+" -> second_arg + first_arg
      "-" -> second_arg - first_arg
    end
  end

  def calc(expr) do
    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> eval([], [])
  end

  def tag_tokens([]), do: []
  def tag_tokens(["*" | rest]), do: [{:op, "*"}              | tag_tokens rest]
  def tag_tokens(["/" | rest]), do: [{:op, "/"}              | tag_tokens rest]
  def tag_tokens(["+" | rest]), do: [{:op, "+"}              | tag_tokens rest]
  def tag_tokens(["-" | rest]), do: [{:op, "-"}              | tag_tokens rest]
  def tag_tokens([num | rest]), do: [{:num, parse_float num} | tag_tokens rest]

  # Step 1.2.1
  def eval([{:num, num} | tail], value_list, op_list),
      do: eval(tail, [num | value_list], op_list)

  # Step 1.2.5
  def eval([{:op, this_op} | tail], value_list, op_list) do
    if op_list != [] && precedence(this_op) <= precedence(hd op_list),
      do: eval(
        tail,
        [apply_op(hd(op_list), hd(value_list), hd(tl(value_list))) | tl(tl(value_list))],
        [this_op | tl op_list]),
      else: eval(tail, value_list, [this_op | op_list])
  end

  # Step 2
  def eval([], [first_arg | [second_arg | value_list]], [first_op | op_list]),
      do: eval([], [apply_op(first_op, first_arg, second_arg) | value_list], op_list)

  # Step 3
  def eval([], [last_value], []), do: last_value
end
