require File.dirname(__FILE__) + '/spec_helper'

describe 'GET /' do
  include Rack::Test::Methods
  
  def app
    Sinatra::Application
  end
  
  it 'should return hello' do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello World'
  end
end