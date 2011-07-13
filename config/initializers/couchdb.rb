require 'couchrest/model'
CouchServer = CouchRest::Server.new # defaults to localhost:5984
CouchServer.default_database = "takeaway"


CouchRest::Model::Base.configure do |config|
  config.model_type_key = 'type'
end