require 'sinatra'
require 'sqlite3'
require 'active_record'
require './lib/rquery-activerecord'

ActiveRecord::Base.include_root_in_json = false

ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database  => ":memory:"
)

ActiveRecord::Schema.define do
  create_table :test_models do |table|
    table.string :name
    table.string :description
    table.date :created_at
  end
end

class TestModel < ActiveRecord::Base
  include RQuery
end



before do
  content_type 'application/json'

  TestModel.create(:name => "foo", :description => "bar", :created_at => "2012-03-08")
  TestModel.create(:name => "afoo", :description => "abar", :created_at => '2012-03-09')
  TestModel.create(:name => "afoo", :description => "aabar", :created_at => '2012-03-10')
  TestModel.create(:name => "bfoo", :description => "bbar", :created_at => '2012-03-11')
  TestModel.create(:name => "cfoo", :description => "cbar", :created_at => '2012-03-12')
  TestModel.create(:name => "foo's", :description => "bar", :created_at => "2012-03-08")
end

after do
  TestModel.delete_all
end


get '/' do
  'Hello World'
end

get '/resources' do
  params.symbolize_keys!
  TestModel.rquery(params).to_json
end
