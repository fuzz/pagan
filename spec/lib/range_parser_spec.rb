require "spec_helper"

# Range: <field> [[<exclusivity operator>]<start identifier>]]..[<end identifier>][; [max=<max number of results>], [order=[<asc|desc>]]

range = "id ]5..10; max=5, order=desc"

describe "RangeParser" do
  describe ".parse" do
    it "parses the field" do
      result = RangeParser.parse "id"

      assert_equal "id", result[:field]
    end

    it "parses a close bracket exclusivity operator" do
      result = RangeParser.parse range

      assert_equal true, result[:exclusive]
    end

    it "parses an open bracket exclusivity operator" do
      result = RangeParser.parse "id [5..10"

      assert_equal false, result[:exclusive]
    end

    it "correctly handles a missing exclusivity operator" do
      result = RangeParser.parse "id 5..10"

      assert_equal false, result[:exclusive]
    end

    it "parses the start identifier" do
      result = RangeParser.parse range

      assert_equal "5", result[:start]
    end

    it "parses the end identifier" do
      result = RangeParser.parse range

      assert_equal "10", result[:finish]
    end

    it "parses the max number of results" do
      result = RangeParser.parse range

      assert_equal "5", result[:max]
    end

    it "provides the default if no max is specified" do
      result = RangeParser.parse "id ]5..10"

      assert_equal "200", result[:max]
    end      

    it "parses the order" do
      result = RangeParser.parse range

      assert_equal "desc", result[:order]
    end

    it "provides the default if no order is specified" do
      result = RangeParser.parse "id ]5..10"

      assert_equal "asc", result[:order]
    end

  end
end
