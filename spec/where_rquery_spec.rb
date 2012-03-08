require File.dirname(__FILE__) + '/spec_helper'

describe 'GET /resources' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context '?where={"name": "foo"}' do
    it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
      get '/resources', :where => "{\"name\":\"foo\"}"
      last_response.headers["Content-Type"].should == 'application/json'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body).first["name"].should == "foo"
      JSON.parse(last_response.body).first["description"].should == "bar"
    end

    it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
      get '/resources', :where => "{\"name\":\"foo2\"}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context '?where={"name": "foo", "desc": "bar"}' do
    it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
      get '/resources', :where => "{\"name\":\"foo\",\"description\":\"bar\"}"
      last_response.headers["Content-Type"].should == 'application/json'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body).first["name"].should == "foo"
      JSON.parse(last_response.body).first["description"].should == "bar"
    end

    it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
      get '/resources', :where => "{\"name\":\"foo\",\"description\":\"bar2\"}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'receives where={"name": "foo", "created_at": {"$gt": "2012-03-01"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at > ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gt\":\"2012-03-01\"}}"
      last_response.headers["Content-Type"].should == 'application/json'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body).first["name"].should == "foo"
      JSON.parse(last_response.body).first["created_at"].should == "2012-03-08T00:00:00-05:00"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at > ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lt\":\"2012-03-01\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'receives where={"name": "foo", "created_at": {"$gte": "2012-03-01"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at >= ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-01\"}}"
      last_response.headers["Content-Type"].should == 'application/json'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body).first["name"].should == "foo"
      JSON.parse(last_response.body).first["created_at"].should == "2012-03-08T00:00:00-05:00"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at >= ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-01\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'receives where={"name": "foo", "created_at": {"$ne": "2012-03-01"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at != ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$ne\":\"2012-03-01\"}}"
      last_response.headers["Content-Type"].should == 'application/json'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body).first["name"].should == "foo"
      JSON.parse(last_response.body).first["created_at"].should == "2012-03-08T00:00:00-05:00"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at != ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":\"2012-03-01\"}"
      JSON.parse(last_response.body).should be_empty
    end
  end

end