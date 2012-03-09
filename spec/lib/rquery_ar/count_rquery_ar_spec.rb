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
        table.date :created_at
      end
    end

    class TestModel < ActiveRecord::Base
      include RQuery
    end

    TestModel.create(:name => "afoo", :description => "abar", :created_at => '2012-03-06')
    TestModel.create(:name => "afoo", :description => "aabar", :created_at => '2012-03-07')
    TestModel.create(:name => "bfoo", :description => "bbar", :created_at => '2012-03-07')
    TestModel.create(:name => "cfoo", :description => "cbar", :created_at => '2012-03-08')

  end

  it 'should return 2' do
    results = TestModel.rquery :where => "{\"name\":\"afoo\"}", :count => "1"
    results.should == 2
  end

  it 'should return 1' do
    results = TestModel.rquery :where => "{\"name\":\"cfoo\"}",  :count => "1"
    results.should == 1
  end

  it 'should return 4' do
    results = TestModel.rquery :count => "1"
    results.should == 4
  end

  it 'should be empty' do
    results = TestModel.rquery :count => "0"
    results.count.should == 4
    results.first.name.should == 'afoo'
  end
end
