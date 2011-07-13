require 'couchrest_model'

class Restaurant < CouchRest::Model::Base
  use_database CouchServer.default_database
  property :name
  property :domain
  property :theme
  
  view_by :domain
  
  def menus
    Menu.by_restaurant(:key => name)
  end
  
  def menus_to_json
    array = []
    menus.each do |menu|
      menu_hash = {}
      menu_hash['id'] = menu.id
      menu_hash['name'] = menu.name
      menu_hash['dishes'] = menu.dishes.map {|dish| dish.dish_to_json}
      array << menu_hash
    end
    array.to_json
  end
  
  def find_menu(slug)
    Menu.by_restaurant_and_slug(:key => [name, slug]).first
  end
  
  def self.find_by_domain(domain)
    Restaurant.by_domain(:key => domain).first
  end
  
end