require File.dirname(__FILE__) + '/spec_helper'

describe 'GET /resources' do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end

  context '?where={"name": "foo"}' do
    it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
      get '/resources', :where => "{\"name\":\"foo\"}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      # JSON.parse("{\"name\":\"foo\", \"description\": \"bar\"}")
      #puts last_response.body
      JSON.parse(last_response.body).first["description"].should == "bar"
    end
  end

  context 'receives where={"name": "foo", "desc": "bar"}' do
    it 'should render { where => [{ :name => "foo", :desc => "bar"}]}'
  end

  context 'receives where={"name": "foo", "created_at": {"$gt": "2012-03-01"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at > ?", "2012-03-01"]] '
  end

  
  it 'should return hello' do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello World'
  end
end
