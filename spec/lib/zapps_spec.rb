require "spec_helper"

# Load test data using "rake init" and "rake load_fixtures"
# [ {id: 1, name: "sourcream"},    {id: 2, name: "saltandvinegar"},
#   {id: 3, name: "plain"},        {id: 4, name: "jalapeno"}, 
#   {id: 5, name: "honeymustard"}, {id: 6, name: "bbq"} ]

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

    it "excludes the finish record upon request" do
      @range[:exclusive] = true
      results = Pagan::Zapps.get @range
      expected_record = {id: 4, name: "jalapeno"}

      assert_equal expected_record, results.last
    end

    it "only returns the requested number of records" do
      @range[:max] = 2
      results = Pagan::Zapps.get @range
      expected_record = {id: 3, name: "plain"}

      assert_equal expected_record, results.last
    end

    it "uses :id if not passed a field" do
      @range[:field] = ""
      results = Pagan::Zapps.get @range

      assert_equal first_record_in_range, results.first
    end

    it "sorts on any field" do
      @range[:field]  = "name"
      @range[:start]  = "jalapeno"
      @range[:finish] = "plain"
      results = Pagan::Zapps.get @range
      expected_record = {id: 4, name: "jalapeno"}

      assert_equal expected_record, results.first
    end

    it "starts at the beginning if no start range is given" do
      @range[:start] = nil
      results = Pagan::Zapps.get @range
      expected_record = {id: 1, name: "sourcream"}

      assert_equal expected_record, results.first
    end

    it "finishes at the end if no finish range is given" do
      @range[:finish] = nil
      results = Pagan::Zapps.get @range
      expected_record = {id: 6, name: "bbq"}

      assert_equal expected_record, results.last
    end

    it "excludes last record if no start range and exclusive is true" do
      @range[:start]     = nil
      @range[:exclusive] = true
      results = Pagan::Zapps.get @range
      expected_record = {id: 4, name: "jalapeno"}

      assert_equal expected_record, results.last
    end
  end
end
