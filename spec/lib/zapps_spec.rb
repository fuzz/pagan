require "spec_helper"

# Load test data using "rake init" and "rake load_fixtures"
# [ {id: 1, "sourcream"}, {id: 2, "saltandvinegar"}, {id: 3, "plain"},
#   {id: 4, "jalapeno"},  {id: 5, "honeymustard"}  , {id: 6, "bbq"} ]

first_record_in_range = {id: 2, name: "saltandvinegar"}
last_record_in_range  = {id: 5, name: "honeymustard"}

describe "Pagan::Zapps" do
  before do
    @range = {
      field: "id",
      exclusive: false,
      start: "2",
      finish: "5",
      max: "10",
      order: "asc"
    }
  end

  describe ".get" do
    it "fetches records" do
      results = Pagan::Zapps.get @range

      assert_equal first_record_in_range, results.first
    end

    it "reverses the order upon request" do
      @range[:order] = "desc"
      results = Pagan::Zapps.get @range

      assert_equal last_record_in_range, results.first
    end

    it "fetches the start record first" do
      @range[:start] = "3"
      results = Pagan::Zapps.get @range
      expected_record = {id: 3, name: "plain"}

      assert_equal expected_record, results.first
    end

    it "fetches the finish record last" do
      @range[:finish] = "4"
      results = Pagan::Zapps.get @range
      expected_record = {id: 4, name: "jalapeno"}

      assert_equal expected_record, results.last
    end
  end
end
