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

    TestModel.create(:name => "foo", :description => "bar", :created_at => '2012-03-08')
  end

  after do
    TestModel.delete_all
  end

  it 'should return [{:created_at => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\"}"
    results[:results].count.should == 1
    results[:results].first[:name].should == "foo"
    results[:results].first[:description].should == "bar"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo2\"}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"description\":\"bar\"}"
    results[:results].count.should == 1
    results[:results].first[:name].should == "foo"
    results[:results].first[:description].should == "bar"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"description\":\"bar2\"}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$gt\":\"2012-03-01\"}}"
    results[:results].count.should == 1
    results[:results].first[:created_at].should == Date.parse("2012-03-08")
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$gt\":\"2012-03-09\"}}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-01\"}}"
    results[:results].count.should == 1
    results[:results].first[:created_at].should == Date.parse("2012-03-08")
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-08\"}}"
    results[:results].count.should == 1
    results[:results].first[:created_at].should == Date.parse("2012-03-08")
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$gte\":\"2012-03-09\"}}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$lt\":\"2012-03-09\"}}"
    results[:results].count.should == 1
    results[:results].first[:created_at].should == Date.parse("2012-03-08")
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$lt\":\"2012-03-07\"}}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08 00:00:00"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-09\"}}"
    results[:results].count.should == 1
    results[:results].first[:created_at].should == Date.parse("2012-03-08")
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-08\"}}"
    results[:results].count.should == 1
    results[:results].first[:created_at].should == Date.parse("2012-03-08")
  end

  it 'should return [{:name => "foo", :description => "bar", :created_at => "2012-03-08"}]' do
    results = TestModel.rquery :where => "{\"name\":\"foo\",\"created_at\":{\"$lte\":\"2012-03-07\"}}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$ne\":\"bar\"}}"
    results[:results].count.should == 1
    results[:results].first[:name].should == "foo"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$ne\":\"foo\"}}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$ne\":\"foo\"}}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$in\":\"('foo','bar')\"}}"
    results[:results].count.should == 1
    results[:results].first[:name].should == "foo"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$in\":\"('foobar')\"}}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$nin\":\"('foobar')\"}}"
    results[:results].count.should == 1
    results[:results].first[:name].should == "foo"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$nin\":\"('foo','bar')\"}}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$exists\":\"1\"}}"
    results[:results].count.should == 1
    results[:results].first[:name].should == "foo"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$exists\":\"0\"}}"
    results[:results].should be_empty
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$like\":\"%oo\"}}"
    results[:results].count.should == 1
    results[:results].first[:name].should == "foo"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$like\":\"f%\"}}"
    results[:results].count.should == 1
    results[:results].first[:name].should == "foo"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$like\":\"%fo%\"}}"
    results[:results].count.should == 1
    results[:results].first[:name].should == "foo"
  end

  it 'should return [{:name => "foo", :description => "bar"}]' do
    results = TestModel.rquery :where => "{\"name\":{\"$like\":\"%bar%\"}}"
    results[:results].should be_empty
  end

  # it 'should return [{:name => "foo", :description => "bar"}]' do
  #   results = TestModel.rquery :where => "{\"name\":{\"$regexp\":\"(foo)\"}}"
  #   results[:results].count.should == 1
  #   results[:results].first[:name].should == "foo"
  # end if ActiveRecord::Base.connection.adapter_name == "MySQL"
  #
  # it 'should return [{:name => "foo", :description => "bar"}]' do
  #   results = TestModel.rquery :where => "{\"name\":{\"$regexp\":\"(bar)\"}}"
  #   results[:results].should be_empty
  # end if ActiveRecord::Base.connection.adapter_name == "MySQL"
end
