class CustomersController < ApplicationController
  include CustomersHelper
  
  def new
    @customer = Customer.new
  end
  
  def edit
    @customer = Customer.find_by_customer_id(params[:id])
  end
  
  def edit_customer
    set_customer_status('open')
    redirect_to edit_order_path(@order)
  end
  
  def create
    customer = Customer.create(params[:customer])
    customer_sign_in customer
    if params[:order]
      handle_redirect
    else
      redirect_to customer
    end
  end
  
  def update
    @customer.update_attributes(params[:customer])
    if params[:order]
      order = Order.find_by_id(params[:order])
      set_customer_status('closed')
      redirect_to edit_order_path(order)
    else
      redirect_to customer
    end
  end
  
  def load_new_customer_form
    @customer = Customer.new
  end
  
  def sign_in
    customer = Customer.authenticate(params[:sign_in][:email], params[:sign_in][:password])
    if customer.nil?
      redirect_to :back, :alert =>"Your email/password combination is invalid"
    else
      customer_sign_in customer
      if params[:order] 
        redirect_to handle_redirect
      else
        redirect_to customer
      end
    end 
  end
  
  def sign_out
    session[:customer_id] = nil
    render :nothing => true
  end
  
end