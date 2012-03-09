require File.dirname(__FILE__) + '/spec_helper'

describe 'GET /resources' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

   it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
    get '/resources', :count => "1"
    last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
    last_response.should be_ok #checks status code 200
    JSON.parse(last_response.body)['count'].should == 5
  end

  it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
    get '/resources', :count => "0"
    last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
    last_response.should be_ok #checks status code 200
    JSON.parse(last_response.body)['results'].count.should == 5
  end

end
