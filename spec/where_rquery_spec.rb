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
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["description"].should == "bar"
    end

    it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
      get '/resources', :where => "{\"name\":\"foo2\"}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end

  context '?where={"name": "foo", "desc": "bar"}' do
    it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
      get '/resources', :where => "{\"name\":\"foo\",\"description\":\"bar\"}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["description"].should == "bar"
    end

    it 'should return json and status 200 and body={"name":"foo", "description": "bar"}' do
      get '/resources', :where => "{\"name\":\"foo\",\"description\":\"bar2\"}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end

  context 'receives where={"name": "foo", "created_at": {"$gt": "2012-03-01"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at > ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gt\":\"2012-03-01\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at > ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gt\":\"2012-03-09\"}}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end

  context 'receives where={"name": "foo", "created_at": {"$gte": "2012-03-01"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at >= ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-01\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at >= ?", "2012-03-08"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-08\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at >= ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-09\"}}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end

  context 'receives where={"name": "foo", "created_at": {"$lt": "2012-03-09"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at < ?", "2012-03-09"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lt\":\"2012-03-09\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at < ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lt\":\"2012-03-01\"}}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end

  context 'receives where={"name": "foo", "created_at": {"$lte": "2012-03-09"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at <= ?", "2012-03-09"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-09\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at <= ?", "2012-03-08"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-08\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at <= ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-01\"}}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end 

  context 'receives where={"name": "foo", "created_at": {"$ne": "2012-03-01"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at != ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$ne\":\"2012-03-01\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at != ?", "2012-03-08"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$ne\":\"2012-03-08\"}}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end

  context 'receives where={"name": "foo", "created_at": {"$in": "(\'2012-03-08\')"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at IN ?", "2012-03-08"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$in\":\"(\'2012-03-08\')\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at IN ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$in\":\"(\'2012-03-01\')\"}}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end

  context 'receives where={"name": "foo", "created_at": {"$nin": "(\'2012-03-08\')"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at NOT IN ?", "2012-03-01"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$nin\":\"(\'2012-03-01\')\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at NOT IN ?", "2012-03-08"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$nin\":\"(\'2012-03-08\')\"}}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end
  
  context 'receives where={"name": "foo", "created_at": {"$exists": "1"}}' do
    it 'should render conditionals where => [{ :name => "foo" }, ["created_at IS NOT NULL"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$exists\":\"1\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should render conditionals where => [{ :name => "foo" }, ["created_at IS NULL"]]' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$exists\":\"0\"}}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end

  context 'receives where={"name": {"$like": "%oo"}}' do
    it 'should render conditionals where => ["name LIKE %oo"]' do
      get '/resources', :where => "{\"name\":{\"$like\":\"%oo\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
    end

    it 'should render conditionals where => ["name LIKE %bar"]' do
      get '/resources', :where => "{\"name\":{\"$like\":\"%bar\"}}"
      JSON.parse(last_response.body)['results'].should be_empty
    end
  end

end
