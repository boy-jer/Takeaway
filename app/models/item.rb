require 'couchrest_model'
class Item < Hash
  include CouchRest::Model::CastedModel
  
  property :dish_name
  property :price
  property :quantity, Integer, :default => 1
  property :dish_id
  
  def total
    price * quantity
  end
  
  def display_name
    quantity > 1 ? "#{dish_name} (x#{quantity})" : dish_name
  end
  
  def increase_quantity
    self['quantity'] += 1
  end
  
  def reduce_quantity
    self['quantity'] -= 1
  end
  
end