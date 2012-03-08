require './lib/rquery_ar'
require 'sqlite3'
require 'active_record'

describe 'Model#rquery' do
  before do
    ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        :database  => ":memory:"
    )
    
    ActiveRecord::Schema.define do
      create_table :test_models do |table|
        table.string :name
        table.string :description
      end
    end    
    
    class TestModel < ActiveRecord::Base
      include RQuery
    end
    
    # Load Data
    
    TestModel.create(:name => "foo", :description => "bar")
  end
  # when I call the rquery method on a ActiveRecord Model, passing
  # Model.rquery { where => {\"name\":\"foo\"} }
  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\"}" 
    results.count == 1
    results.first[:name].should == "foo"
    results.first[:description].should == "bar"
  end
end