class Dish < CouchRest::Model::Base
  use_database CouchServer.default_database

  property :name
  property :description
  property :price_points, :cast_as => [PricePoint]
  property :css_id
  property :dish_id, Integer
  property :vegetarian, :cast_as => TrueClass, :default => false
  property :menu_id, Integer
  
  view_by :dish_id
  view_by :menu_id
  
  set_callback :create, :before, :set_dish_id
  
  def set_dish_id
    self['dish_id'] = Dish.max_dish_id + 1
  end
  
  def self.max_dish_id
    dish_ids = Dish.all.collect {|dish| dish.dish_id}
    Integer(dish_ids.max)
  end
  
  def self.find_dish(dish_id)
    Dish.by_dish_id(:key => dish_id).first
  end
  
  def dish_to_json
    dish_hash = {}
    dish_hash['name'] = name
    dish_hash['description'] = description
    dish_hash['price'] = price_points.first.price
    dish_hash['dish_id'] = dish_id
    dish_hash
  end
  
  def menu
    Menu.find_by_id(menu_id)
  end
    
end