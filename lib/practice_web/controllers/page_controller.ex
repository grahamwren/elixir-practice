defmodule PracticeWeb.PageController do
  use PracticeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def double(conn, %{"x" => x}) do
    {x, _} = Integer.parse x
    y = Practice.double x
    render conn, "double.html", x: x, y: y
  end

  def calc(conn, %{"expr" => expr}) do
    y = Practice.calc expr
    render conn, "calc.html", expr: expr, y: y
  end

  def factor(conn, %{"x" => x}) do
    {:ok, num} = Practice.Factor.parse_int x
    y = Practice.factor num
    render conn, "factor.html", x: x, y: y
  end

  def pal(conn, %{"s" => s}) do
    s
    |> Practice.pal
    |> (&render(conn, "pal.html", s: s, pal?: &1)).()
  end
end
