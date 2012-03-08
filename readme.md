# rquery

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
