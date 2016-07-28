require File.dirname(__FILE__) + '/spec_helper'

describe 'GET /resources' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it 'should return results where name equals foo or description equals bar' do
    get '/resources', :or => "{\"name\":\"foo\",\"description\":\"bar\"}"
    last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
    last_response.should be_ok #checks status code 200
    JSON.parse(last_response.body)['results'].first["name"].should == "foo"
    JSON.parse(last_response.body)['results'].first["description"].should == "bar"
    JSON.parse(last_response.body)['results'].last["name"].should == "foo's"
    JSON.parse(last_response.body)['results'].last["description"].should == "bar"
  end

  it 'should return results using actions' do
    get '/resources', :or => "{\"name\":\"foo\",\"created_at\":{\"$gt\":\"2012-03-01\"}}"
    last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
    last_response.should be_ok #checks status code 200
    JSON.parse(last_response.body)['results'].first["name"].should == "foo"
    JSON.parse(last_response.body)['results'].first["description"].should == "bar"
    JSON.parse(last_response.body)['results'].last["name"].should == "cfoo"
    JSON.parse(last_response.body)['results'].last["description"].should == "cbar"
  end

end
