defmodule ScrumPoker.ReportingTest do
  use ExUnit.Case

  alias ScrumPoker.Reporting

  doctest ScrumPoker.Reporting

  describe "average" do
    test "returns nil with no valid cards" do
      assert Reporting.average(:linear, []) == nil
      assert Reporting.average(:tshirt, []) == nil
      assert Reporting.average(:fibonacci, []) == nil
      assert Reporting.average(:linear, ["🤷‍♀️"]) == nil
      assert Reporting.average(:tshirt, ["🤷‍♀️"]) == nil
      assert Reporting.average(:fibonacci, ["🤷‍♀️"]) == nil
    end

    test "returns the linear average" do
      assert Reporting.average(:linear, ["1", "2", "3"]) == 2
      assert Reporting.average(:linear, ["2", "2", "2"]) == 2
      assert Reporting.average(:linear, ["1", "1", "☕️"]) == 1
    end

    test "returns the fibonacci average" do
      assert Reporting.average(:fibonacci, ["1", "2", "3"]) == 2
      assert Reporting.average(:fibonacci, ["2", "2", "2"]) == 2
      assert Reporting.average(:fibonacci, ["1", "2", "☕️"]) == 1
      assert Reporting.average(:fibonacci, ["3", "3", "3"]) == 3
      assert Reporting.average(:fibonacci, ["8", "8", "8"]) == 8
      assert Reporting.average(:fibonacci, ["8", "13", "144"]) == 55
      assert Reporting.average(:fibonacci, ["144", "144", "144"]) == 144
    end

    test "returns the tshirt average" do
      assert Reporting.average(:tshirt, ["XS", "SM", "MD"]) == "SM"
      assert Reporting.average(:tshirt, ["SM", "SM", "SM"]) == "SM"
      assert Reporting.average(:tshirt, ["XS", "XS", "☕️"]) == "XS"
      assert Reporting.average(:tshirt, ["XS", "LG", "XL", "XL"]) == "LG"
      assert Reporting.average(:tshirt, ["MD", "LG", "LG", "LG"]) == "LG"
    end
  end

  describe "minimum" do
    test "returns nil with no valid cards" do
      assert Reporting.minimum(:linear, []) == nil
      assert Reporting.minimum(:tshirt, []) == nil
      assert Reporting.minimum(:fibonacci, []) == nil
      assert Reporting.minimum(:linear, ["🤷‍♀️"]) == nil
      assert Reporting.minimum(:tshirt, ["🤷‍♀️"]) == nil
      assert Reporting.minimum(:fibonacci, ["🤷‍♀️"]) == nil
    end

    test "returns the linear minimum" do
      assert Reporting.minimum(:linear, ["1", "2", "3"]) == 1
      assert Reporting.minimum(:linear, ["2", "2", "2"]) == 2
      assert Reporting.minimum(:linear, ["1", "1", "☕️"]) == 1
    end

    test "returns the fibonacci minimum" do
      assert Reporting.minimum(:fibonacci, ["1", "2", "3"]) == 1
      assert Reporting.minimum(:fibonacci, ["2", "2", "2"]) == 2
      assert Reporting.minimum(:fibonacci, ["1", "2", "☕️"]) == 1
      assert Reporting.minimum(:fibonacci, ["3", "3", "3"]) == 3
      assert Reporting.minimum(:fibonacci, ["8", "8", "8"]) == 8
      assert Reporting.minimum(:fibonacci, ["8", "13", "144"]) == 8
      assert Reporting.minimum(:fibonacci, ["144", "144", "144"]) == 144
      assert Reporting.minimum(:fibonacci, ["2", "144", "144"]) == 2
    end

    test "returns the tshirt mimimum" do
      assert Reporting.minimum(:tshirt, ["XS", "SM", "MD"]) == "XS"
      assert Reporting.minimum(:tshirt, ["SM", "SM", "SM"]) == "SM"
      assert Reporting.minimum(:tshirt, ["XS", "XS", "☕️"]) == "XS"
      assert Reporting.minimum(:tshirt, ["XS", "LG", "XL", "XL"]) == "XS"
      assert Reporting.minimum(:tshirt, ["MD", "LG", "LG", "LG"]) == "MD"
    end
  end

  describe "maximum" do
    test "returns nil with no valid cards" do
      assert Reporting.maximum(:linear, []) == nil
      assert Reporting.maximum(:tshirt, []) == nil
      assert Reporting.maximum(:fibonacci, []) == nil
      assert Reporting.maximum(:linear, ["🤷‍♀️"]) == nil
      assert Reporting.maximum(:tshirt, ["🤷‍♀️"]) == nil
      assert Reporting.maximum(:fibonacci, ["🤷‍♀️"]) == nil
    end

    test "returns the linear maximum" do
      assert Reporting.maximum(:linear, ["1", "2", "3"]) == 3
      assert Reporting.maximum(:linear, ["2", "2", "2"]) == 2
      assert Reporting.maximum(:linear, ["1", "1", "☕️"]) == 1
    end

    test "returns the fibonacci maximum" do
      assert Reporting.maximum(:fibonacci, ["1", "2", "3"]) == 3
      assert Reporting.maximum(:fibonacci, ["2", "2", "2"]) == 2
      assert Reporting.maximum(:fibonacci, ["1", "2", "☕️"]) == 2
      assert Reporting.maximum(:fibonacci, ["3", "3", "3"]) == 3
      assert Reporting.maximum(:fibonacci, ["8", "8", "8"]) == 8
      assert Reporting.maximum(:fibonacci, ["8", "13", "144"]) == 144
      assert Reporting.maximum(:fibonacci, ["144", "144", "144"]) == 144
      assert Reporting.maximum(:fibonacci, ["2", "144", "144"]) == 144
    end

    test "returns the tshirt maximum" do
      assert Reporting.maximum(:tshirt, ["XS", "SM", "MD"]) == "MD"
      assert Reporting.maximum(:tshirt, ["SM", "SM", "SM"]) == "SM"
      assert Reporting.maximum(:tshirt, ["XS", "XS", "☕️"]) == "XS"
      assert Reporting.maximum(:tshirt, ["XS", "LG", "XL", "XL"]) == "XL"
      assert Reporting.maximum(:tshirt, ["MD", "LG", "LG", "LG"]) == "LG"
    end
  end
end
