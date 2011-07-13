module MenusHelper
  def display_menu_name(menu)
    if menu.slug == params[:menu_id]
      link_to menu.name, orders_menu_path(menu), :class => "selected"
    else
      link_to menu.name, orders_menu_path(menu)
    end
  end
  
  def display_price(price)
    pence = price.to_f / 100
    number_to_currency pence, :unit => '£', :separator => ".", :delimiter => ","
  end
  
  def display_dish(order, dish, &block)
    if order.dish_already_added?(dish.dish_id)
      content_tag(:div, :class => 'dish dish_added', &block)
    else
      content_tag(:div, :class => 'dish', &block)
    end
  end
  
  def add_dish_button(order, dish)
    if order.dish_already_added?(dish.dish_id)
      submit_tag '+1', :name => "increas_item_quantity[#{dish.dish_id}]"
    else
      submit_tag 'Add', :name => "add_item[#{dish.dish_id}]"
    end
  end
  
  def remove_dish_button(order, dish)
    if order.dish_already_added?(dish.dish_id)
      submit_tag 'Remove', :name => "remove_item[#{dish.dish_id}]"
    else
      return
    end
    
  end
end