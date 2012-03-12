[![Build Status](https://secure.travis-ci.org/jackhq/rquery.png)](http://travis-ci.org/jackhq/rquery)

# rquery spec

rquery spec is a collection of rquery gems for several different orm and
database driver libraries.

rquery will receive a domain specific query language that needs to be
converted to the orm or database dsl.  Each rquery gem will act as the
coversion and return the requested results.

RQuery Spec is a spec suite test application that will maintain the
current version of rquery spec tests that will keep each gem up to
compliance with the api.

## install

    gem install rquery

## install rquery active record

gem install rquery-ar

## run specs

rquery-spec rquery-ar
#> Specs passed 0 out of 100


Below are some test cases:

A ruby gem that takes a ruby hash that specifies the where, order, limit, select, etc nodes of an active relation and converts it into an a set of objects


case 1
---

/patients?where={"last_name": "foo"}

=>

where => "{"last_name": "foo"}"

JSON.parse(where)

=>

{ "last_name": "foo" }

Patient.where({ "last_name": "foo" })


case 2
---

/patients?where={"last_name": {"$like": "foo%"}}

=> where => "{"last_name": {"$like": "foo%" }}"

JSON.parse(where)

=> { "last_name": {"$like" => "foo%" }}

needs to convert to

Patient.where("last_name like ?", "foo%")

case 3
---

/patients?where={"created_at": {"$gt": "2012-03-01"}}

=> where => "{"created_at": {"$gt": "2012-03-01"}}"

JSON.parse(where)

=> {"created_at" => {"$gt" => "2012-03-01"}}

needs to convert to

Patient.where("created_at > ?", "2012-03-01")

case 4

----

/patients?where={"created_at": {"$gt": "2012-03-01"}, "first_name": "Tom"}

=> where => "{"created_at": {"$gt": "2012-03-01"}, "first_name": "Tom"}"

JSON.parse(where)

=> {"created_at" => {"$gt" => "2012-03-01"}, "first_name" => "Tom"}

needs to convert to

Patient.where("created_at > ?", "2012-03-01").where("first_name" => "Tom")


case 5
----

/patients?where={"created_at": {"$gt": "2012-03-01"}, "first_name": "Tom"}&order="updated_at DESC"

=> where => "{"array" => ["foo > ?","bar"], "first_name": "Tom"}"
=> order => "updated_at DESC"

JSON.parse(where)

=> {"created_at" => {"$gt" => "2012-03-01"}, "first_name" => "Tom"}


needs to convert to

Patient.where("created_at > ?", "2012-03-01").where("first_name" => "Tom").order("updated_at DESC")
