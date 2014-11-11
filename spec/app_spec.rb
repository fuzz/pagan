require "spec_helper"

describe "Pagan App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "responds properly without a Range header" do
    get "/"
    assert_equal 200, last_response.status
    assert_match /id/i, last_response.body
  end

  it "responds properly with a Range header" do
    header "Range", "id ]5..10; max=5, order=desc"
    get "/"
    assert_equal 200, last_response.status
    assert_match /id/i, last_response.body
  end
end
