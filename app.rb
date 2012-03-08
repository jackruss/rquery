require 'sinatra'
require 'sqlite3'
require 'active_record'
require './lib/rquery_ar'

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

TestModel.create(:name => "foo", :description => "bar")

before do
  content_type 'application/json'
end


get '/' do
  'Hello World'
end

get '/resources' do
  params.symbolize_keys!
  TestModel.rquery(params).to_json
end
