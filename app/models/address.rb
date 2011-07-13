require 'couchrest_model'
class Address < Hash
  include CouchRest::Model::CastedModel
  
  property :address1
  property :address2
  property :town_city
  property :postcode

end