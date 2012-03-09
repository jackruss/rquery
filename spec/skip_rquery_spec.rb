require File.dirname(__FILE__) + '/spec_helper'

describe 'GET /resources' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'skip the first three records and return a results array with 2 records' do
    get '/resources', :skip => "3"
    last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
    last_response.should be_ok #checks status code 200
    JSON.parse(last_response.body)['results'].count.should == 2
  end
end
