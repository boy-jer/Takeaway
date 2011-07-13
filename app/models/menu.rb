class Menu < CouchRest::Model::Base
  use_database CouchServer.default_database
  
  property :name
  property :dishes, :default => []
  property :restaurant
  property :slug
  property :menu_id, Integer
  
  view_by :restaurant
  view_by :menu_id
  view_by :slug

  view_by :restaurant_and_slug,  :map =>
  "function(doc) {
    if ((doc['type'] == 'Menu') && (doc['slug'] != null)) {
      emit([doc['restaurant'], doc['slug']], null);
    }
  }"


  set_callback :create, :before, :set_slug, :set_menu_id
  
  def set_slug
    slug = name.parameterize('_').to_s
    self['slug'] = slug
  end
  
  def to_param
    slug
  end  
  
  def set_menu_id
    self['menu_id'] = Menu.max_menu_id + 1
  end
  
  def self.max_menu_id
    menu_ids = Menu.all.collect {|menu| menu.menu_id}
    Integer(menu_ids.max)
  end
  
  
  def find_dish(dish_id)
    Dish.all.find {|dish| dish.dish_id == dish_id}
  end
  
  def self.find_by_id(menu_id)
    Menu.by_menu_id(:key => menu_id.to_i).first
  end
  
  def self.find_by_slug(slug)
    Menu.by_slug(:key => slug).first
  end
  
  def dishes
    Dish.by_menu_id(:key => menu_id)
  end
  
  def menu_to_json
    menu_hash = {}
    menu_hash['menu_id'] = menu_id
    menu_hash['name'] = name
    menu_hash['dishes'] = dishes.map {|dish| dish.dish_to_json}
    menu_hash.to_json
  end
  
end