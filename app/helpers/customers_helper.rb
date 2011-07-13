module CustomersHelper  
  def customer_sign_in(customer)
    customer.remember_me!
    cookies[:remember_token] = {:value => customer.remember_token, :expires => 20.years.from_now.utc}
    session[:customer_id] = customer.customer_id  
  end
  
  def customer_address_info(customer, field)
    return if customer.new?
    customer["address"][field]
  end  
  
  def display_password_fields(customer, &block)  
    content_tag(:div, nil, &block) if customer.new?
  end
  
  def render_submit_button(customer)
    customer.new? ? submit_tag('Sign up') : submit_tag('Save')
  end
  
end