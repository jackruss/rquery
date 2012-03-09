require File.dirname(__FILE__) + '/spec_helper'

describe 'GET /resources' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context '?order=["created_at"]' do
    it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
      get '/resources', :order => "[\"name\"]"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body).first["name"].should == "afoo"
      JSON.parse(last_response.body).first["description"].should == "abar"
    end
  end

end
