class PricePoint < Hash
  include CouchRest::Model::CastedModel

  property :price
  property :description
  property :supplement
  property :supplement_description
  property :per_person, TrueClass, :default => false
  
end