require File.dirname(__FILE__) + '/spec_helper'

describe 'GET /resources' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'should order by name ascending' do
    get '/resources', :order => "[\"name\"]"
    last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
    last_response.should be_ok #checks status code 200
    JSON.parse(last_response.body)['results'].first["name"].should == "afoo"
    JSON.parse(last_response.body)['results'].first["description"].should == "abar"
  end

  it 'should order by name ascending' do
    get '/resources', :order => "[\"name DESC\"]"
    last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
    last_response.should be_ok #checks status code 200
    JSON.parse(last_response.body)['results'].first["name"].should == "foo's"
    JSON.parse(last_response.body)['results'].first["description"].should == "bar"
  end

  it 'should order by name ascending' do
    get '/resources', :order => "[\"created_at DESC\"]"
    last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
    last_response.should be_ok #checks status code 200
    JSON.parse(last_response.body)['results'].first["name"].should == "cfoo"
    JSON.parse(last_response.body)['results'].first["description"].should == "cbar"
  end

end
