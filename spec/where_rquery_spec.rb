require File.dirname(__FILE__) + '/spec_helper'

describe 'GET /resources' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context 'where single attribute' do
    it 'should return results where name equals foo' do
      get '/resources', :where => "{\"name\":\"foo\"}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["description"].should == "bar"
    end

    it 'should return not return any results where name equals foo2' do
      get '/resources', :where => "{\"name\":\"foo2\"}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where multiple attributes' do
    it 'should return a result where name equals foo and description equals bar' do
      get '/resources', :where => "{\"name\":\"foo's\",\"description\":\"bar\"}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo's"
      JSON.parse(last_response.body)['results'].first["description"].should == "bar"
    end

    it 'should not return any results where name equals foo and description equals bar2' do
      get '/resources', :where => "{\"name\":\"foo\",\"description\":\"bar2\"}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where greater than' do
    it 'should return a result where name equals foo and created at is greater than 2012-03-01' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gt\":\"2012-03-01\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should not return any results where name equals foo and created at is greater than 2012-03-09' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gt\":\"2012-03-09\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where greater than or equals' do
    it 'should return a result where name equals foo and created at is greater than or equal to 2012-03-01' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-01\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should return a result where name equals foo and created at is greater than or equal to 2012-03-08' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-08\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should not return any results where name equals foo and created at is greater than or equal to 2012-03-09' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-09\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where less than' do
    it 'should return a result where name equals foo and created at is less than to 2012-03-09' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lt\":\"2012-03-09\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should not return any results where name equals foo and created at is less than 2012-03-01' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lt\":\"2012-03-01\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where less than or equals' do
    it 'should return a result where name equals foo and created at is less than or equal to 2012-03-09' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-09\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should return a result where name equals foo and created at is less than or equal to 2012-03-08' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-08\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should not return any results where name equals foo and created at is less than or equal to 2012-03-01' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-01\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where not equals' do
    it 'should return a result where name equals foo and created at is not equal to 2012-03-01' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$ne\":\"2012-03-01\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should not return any results where name equals foo and created at is not equal to 2012-03-08' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$ne\":\"2012-03-08\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where in' do
    it 'should return a result where name equals foo and created at in ("2012-03-08")' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$in\":\"(\'2012-03-08\')\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should not return any results where name equals foo and created at in ("2012-03-01")' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$in\":\"(\'2012-03-01\')\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where not in' do
    it 'should return a result where name equals foo and created at not in ("2012-03-01")' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$nin\":\"(\'2012-03-01\')\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should not return any results where name equals foo and created at not in ("2012-03-08")' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$nin\":\"(\'2012-03-08\')\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where exists' do
    it 'should return a result where name equals foo and created at IS NOT NULL' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$exists\":\"1\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
      JSON.parse(last_response.body)['results'].first["created_at"].should == "2012-03-08"
    end

    it 'should not return any results where name equals foo and created at IS NULL' do
      get '/resources', :where => "{\"name\":\"foo\",\"created_at\":{\"$exists\":\"0\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

  context 'where like' do
    it 'should return a result where name LIKE %oo' do
      get '/resources', :where => "{\"name\":{\"$like\":\"%oo\"}}"
      last_response.headers["Content-Type"].should == 'application/json;charset=utf-8'
      last_response.should be_ok #checks status code 200
      JSON.parse(last_response.body)['results'].first["name"].should == "foo"
    end

    it 'should not return any results where name LIKE %bar' do
      get '/resources', :where => "{\"name\":{\"$like\":\"%bar\"}}"
      JSON.parse(last_response.body).should be_empty
    end
  end

end
