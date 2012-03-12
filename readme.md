# RQuery

  Queries for your restful api!

[![Build Status](https://secure.travis-ci.org/jackruss/rquery.png?branch=master)](http://travis-ci.org/jackruss/rquery)

# What is RQuery?

Rquery is a ruby gem that will allow you to pass queries into your restful api as json.  It will take the json formatted queries and convert them into an orm or datasource specific query (currently only ActiveRecord is supported).

    http://example.com/users?where={"name":{"foo"}}


# Install

In your Gemfile

    gem 'rquery', '~> 0.1.0'

# Usage

## ActiveRecord

In your controller:

    class UsersController < ApplicationController

      def index
        @users = User.rquery params
        respond_with @users
      end

    end

In your model:

    class User < ActiveRecord::Base

      include RQuery

    end

### Queries

Field | Values | Required | type | Description
------|--------|----------|------|-------------
where | [[queries]] | No | JSON | filter criteria for results
order | [[queries]] | No | array| array of columns you want to sort by, prepend DESC to indicate descending, default is ascending
count | [[queries]] | No | Integer(=1) | returns the number of results
limit | [[queries]] | No | Integer | number of medications to return
skip  | [[queries]] | No | Integer | number of records to skip
include | [[queries]] | No | Array | array of models to include as full docs instead of pointer


### Where Attributes

Key | Description
----|------------
$lt | Less Than
$lte | Less Than or Equal
$gt | Greater Than
$gte | Greater Than or Equal
$ne  | Not Equal To
$in  | Contained In
$nin | Not Contained In
$exists | A value is set for the key
$like | partial match
$regex | regex match

### Basic Usage

    User.rquery :where => '{"first_name":"foo"}'

Returns

    {:results=>[{#<User id: 1, first_name:"foo", last_name:"bar"},{#<User id: 2, first_name:"foo", last_name:"Baz"}]}

### Chaining queries

    User.rquery :where => '{"first_name":"foo"}', :order => '["last_name DESC"]', :count => '1'

Returns

    {:results=>[{#<User id: 2, first_name:"foo", last_name:"Baz"},{#<User id: 1, first_name:"foo", last_name:"bar"}],:count =>2}


## JSON Examples

### Where
#### where single equals:

    {
      "where": {"name":"foo2"}
    }

Returns all records where name equals "foo2"

#### where multiple equals:

    {
      "where": {"name":"foo","description":"bar"}
    }

Returns all records where name equals "foo" and description equals "bar"

#### where less than:

    {
      "where": {"id":{"$lt":"2"}}
    }

Returns all records where id is less than "2"

#### where less than or equal to:

    {
      "where": {"id":{"$lte":"2"}}
    }

Returns all records where id is less than or equal to "2"

#### where greater than:

    {
      "where": {"id":{"$gt":"2"}}
    }

Returns all records where id is greater than "2"

#### where greater than or equal to:

    {
      "where": {"id":{"$gte":"2"}}
    }

Returns all records where id is greater than or equal to "2"

#### where not equal to:

    {
      "where": {"name":{"$ne":"bar"}}
    }

Returns all records where name is not equal to "bar"

#### where in:

    {
      "where": {"name":{"$in":"('foo','bar')"}}
    }

Returns all records where name equals "foo" or "bar"

#### where not in:

    {
      "where": {"name":{"$nin":"('foo','bar')"}}
    }

Returns all records where name does not equal "foo" or "bar"

#### where exists true:

    {
      "where": {"name":{"$exists":"1"}}
    }

Returns all records where name is not null

#### where exists false:

    {
      "where": {"name":{"$exists":"0"}}
    }

Returns all records where name is null

#### where like:

    {
      "where": {"name":{"$like":"%oo"}}
    }

and

    {
      "where": {"name":{"$like":"f%"}}
    }

and

    {
      "where": {"name":{"$like":"%fo%"}}
    }

Each will return the record where name equals "foo"

#### where regexp:

**Note**: only works with mysql

    {
      "where": {"name":{"$regexp":"(foo)"}}
    }

Returns all records where name matches "foo"

### Order Attribute

Array of columns to sort on, if the column is prepended with a DESC string, then the column will sort in descending.

    {
      "order": ["updated_at DESC"]
    }

### Count Attribute

If set to 1 then the results will return the record count of the query.


This example will just return the count of records with a workflow_state of active

    {
      "where": { "workflow_state": "active" },
      "count": 1,
      "limit": 0
    }

Returns

    {
      "results": [],
      "count": 4000
    }

With a nonzero limit, that request would return results as well as the count.

### Limit

The number of records you want to return

    {
      "where": { "workflow_state": "active" },
      "limit": 10
    }

Returns the first 10 objects

### Skip

The number of records you want to skip

    {
      "where": { "workflow_state": "active" },
      "limit": 10,
      "skip": 10
    }

Returns the next 10 objects





## Testing the gem

    bundle install

    bundle exec rspec spec