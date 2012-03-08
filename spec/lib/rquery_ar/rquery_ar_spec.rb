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
        table.timestamps
      end
    end

    class TestModel < ActiveRecord::Base
      include RQuery
    end

    # Load Data

    TestModel.create(:name => "foo", :description => "bar", :created_at => '2012-03-08 00:00:00')
  end
  # when I call the rquery method on a ActiveRecord Model, passing
  # Model.rquery { where => {\"name\":\"foo\"} }
  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\"}"
    results.count.should == 1
    results.first[:name].should == "foo"
    results.first[:description].should == "bar"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo2\"}"
    results.should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"description\":\"bar\"}"
    results.count.should == 1
    results.first[:name].should == "foo"
    results.first[:description].should == "bar"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"description\":\"bar2\"}"
    results.should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08 00:00:00"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$gt\":\"2012-03-01\"}}"
    results.count.should == 1
    results.first[:created_at].should == DateTime.parse("Thu Mar 08 00:00:00 -0500 2012")
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08 00:00:00"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$lt\":\"2012-03-01\"}}"
    results.should be_empty
  end
end