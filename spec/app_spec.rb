require "spec_helper"

describe "Pagan App" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "says hello" do
    get "/"
    assert_equal 200, last_response.status
    assert_match /id/i, last_response.body
  end
end
