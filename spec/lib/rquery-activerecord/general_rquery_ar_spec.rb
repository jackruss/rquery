require './lib/rquery-activerecord'
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

  after do
    TestModel.delete_all
  end

  it 'should return nil if no rquery arguments' do
    results = TestModel.rquery
    results.should == {}
  end

end

