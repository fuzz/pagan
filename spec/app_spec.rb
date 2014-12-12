require "spec_helper"

describe "Pagan App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "responds properly without a provided Range header" do
    get "/"
    assert_equal 200, last_response.status
    assert_match /name/i, last_response.body
    assert_equal "id 1..6", last_response.headers["Content-Range"]
    assert_equal "6; max=200, order=asc", last_response.headers["Next-Range"]
  end

  it "responds properly with a provided Range header" do
    header "Range", "id ]1..5; max=2, order=desc"
    get "/"
    assert_equal 200, last_response.status
    assert_match /name/i, last_response.body
    assert_equal "id 4..3", last_response.headers["Content-Range"]
    assert_equal "]3; max=2, order=desc", last_response.headers["Next-Range"]
  end
end
