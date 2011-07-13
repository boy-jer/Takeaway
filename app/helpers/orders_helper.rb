module OrdersHelper
  def basket_contents
    if session[:order_id].nil? || @order.items.empty?
      content_tag(:div, "You have no items in your basket")
    else
      render 'layouts/basket'
    end
  end
  
  def render_schedule
    render :partial => "orders/schedule/form"
  end
  
  def render_schedule_show(order)
    if order.delivery_type == 'collection'
      content_tag(:div, "Your order will be available for collection from #{order.delivery_time}")
    else
      content_tag(:div, "Your order will be delivered at #{order.delivery_time}")
    end
  end
  
  def render_customer(customer_status)
    if params[:customer_status] == 'new'
      render :partial => "customers/form"
    else
      render :partial => "customers/sign_in"
    end
  end
  
  def order_in_process?
    request.path.include?('orders')
  end
  
  def display_order_field?
    order_in_process? ? hidden_field_tag('order', params[:id]) : return
  end
  
  def submit_buttons_for_schedule
    if @customer.nil?
      render 'orders/schedule/submit_for_nil_customer'
    else
      render 'orders/schedule/submit_for_customer'
    end
  end
  
  def display_schedule
    if session[:schedule_status] == 'closed'
      render 'orders/schedule/show'
    else
      render 'orders/schedule/form'
    end
  end
  
  def display_customer
    if session[:customer_status] == 'open'
      partial = @customer.nil? ? 'customers/new_existing' : 'customers/form'
      render partial
    else
      partial = @customer.nil? ? 'customers/default' : 'customers/show'
      render partial
    end    
  end
  
  def display_items
    if session[:items_status] == 'open'
      render 'orders/items/edit'
    else
      render 'orders/items/default'
    end
  end
  
  def order_section(section, &block)
    if session["#{section}_status"] == 'open'
      content_tag(:div, :class => 'order_section open', &block)
    else
      content_tag(:div, :class => 'order_section', &block)
    end
  end
  
end