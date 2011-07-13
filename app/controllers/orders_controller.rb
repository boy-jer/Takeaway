class OrdersController < ApplicationController
  
  def new
    clear_order_session_id
    @order = Order.new
  end
  
  def edit
    @order = Order.find_by_id(params[:id])
    @menu = @restaurant.menus.first
    @menus = @restaurant.menus
    @menus_json = @restaurant.menus_to_json
    @items_json = @order.items.to_json
  end
  
  def update
    @order = Order.find_by_id(params[:id])
    @menus = @restaurant.menus
    @order.update_order(params)
  end
  
  def update_schedule
    set_schedule_status('closed')
    @order.update_schedule(params[:order])
    redirect_to edit_order_path(@order)
  end
  
  def edit_schedule
    @order = Order.find_by_id(params[:id])
    set_schedule_status('open')
    redirect_to edit_order_path(@order)
  end

  def edit_items
    @order = Order.find_by_id(params[:id])    
    set_items_status('open')
    redirect_to edit_order_path(@order)
  end
  
  def edit_customer
    @order = Order.find_by_id(params[:id])
    set_customer_status('open')
    redirect_to edit_order_path(@order)
  end
    
  def create
    order = Order.create(:site => @restaurant.domain)
    set_order_session_id(order)
    redirect_to :controller => 'menus', :action => 'show', :id => 'starter'
  end
  
  def customer
    @customer = Customer.new
    @customer_status = params[:customer_status]
  end
  
  def menus
    @menu = params[:menu_id] ? Menu.find_by_slug(params[:menu_id]) : @restaurant.menus.first
  end
  
  def from_gwt
    @order = Order.find_by_id(params[:id])
    @order.update_gwt_items(params[:order_data])
    set_items_status('closed')
    render :nothing => true
  end
  
end