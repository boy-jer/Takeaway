class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :setup_restaurant, :find_order, :find_customer
  layout :choose_layout

  def setup_restaurant
    @restaurant = Restaurant.find_by_domain(request.domain(2))
  end
  
  def choose_layout
    @restaurant.theme
  end
  
  def find_order
    @order = session[:order_id].nil? ? Order.new : Order.find_by_session(session[:order_id])
  end
  
  def find_customer
    @customer = Customer.find_by_session(session[:customer_id])
  end
  
  def set_order_session_id(order)
    session[:order_id] = order.order_id
  end
  
  def set_schedule_status(state)
    session[:schedule_status] = state
  end

  def set_customer_status(state)
    session[:customer_status] = state
  end

  def set_items_status(state)
    session[:items_status] = state
  end
  
  def clear_order_session_id
    session[:order_id] = nil
  end
  
  def set_order_step(step)
    session[:order_step] = step
  end
  
  def handle_redirect(options = {})
    if @order.delivery_type.nil?
      redirect_to schedule_orders_path
    elsif !@order.delivery_type.nil? && @customer.nil?
      redirect_to customer_orders_path(options)
    else !@order.delivery_type.nil? && !@customer.nil?
      redirect_to menus_orders_path
    end
  end

end
