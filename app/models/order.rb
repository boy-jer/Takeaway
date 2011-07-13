class Order < CouchRest::Model::Base
  use_database CouchServer.default_database
    
  property :order_id
  property :items, :cast_as => [Item]
  property :customer_id
  property :delivery_type
  property :delivery_time
  property :restaurant
  
  view_by :order_id
  
  set_callback :create, :before, :set_order_id
  
  def to_param
    order_id.to_s
  end
  
  def set_order_id
    self['order_id'] = Order.max_order_id + 1
  end
  
  def self.max_order_id
    order_ids = Order.all.collect {|order| order.order_id}
    Integer(order_ids.max)
  end
  
  def self.find_by_session(session)
    Order.by_order_id(:key => session).first
  end
  
  def self.find_by_id(id)
    Order.by_order_id(:key => id.to_i).first
  end
  
  def add_item(params)
    if params[:increase_item_quantity]
      dish_id = params[:increase_item_quantity].invert['+1'].to_i
      item = items.find {|item| item.dish_id == dish_id}
      item.increase_quantity
    else
      dish_id = params[:add_item].invert['Add'].to_i
      dish = Dish.find_dish(dish_id)
      self.items << Item.new(:name => dish.name, :price => dish.price_points.first.price, :quantity => 1, :dish_id => dish.dish_id)
    end
  end
  
  def increase_item_quantity
    dish_id = params[:increase_item_quantity].invert['+1'].to_i
    dish = Dish.find_dish(dish_id)
  end
  
  def dish_already_added?(dish_id)
    existing_dish_ids = items.collect {|item| item.dish_id}
    existing_dish_ids.include?(dish_id)
  end
  
  def remove_item(params)
    dish_id = params[:remove_item].invert['Remove'].to_i
    item = items.find{|item| item.dish_id == dish_id}
    item_index = items.index(item)
    if item.quantity > 1
      item.reduce_quantity
    else
      items.delete_at(item_index)
    end
  end
  
  def update_order(params)
    if params[:add_item]
      add_item(params)
    elsif params[:remove_item]
      remove_item(params)
    end
    self.save!
  end
  
  def update_gwt_items(order_items)
    self.items = order_items
    save!
  end
  
  def update_schedule(params)
    replace(Order.new(self.merge!(params)))
    save!
  end
  
  def total
    item_totals = items.collect {|item| item.total }
    item_totals.inject { |a, b| a + b }
  end
  
end