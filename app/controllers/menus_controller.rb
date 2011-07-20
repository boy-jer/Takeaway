class MenusController < ApplicationController
  layout :pages_layout
  
  def index
    @menus = @restaurant.menus
  end
  
  def show
    @menu = @restaurant.find_menu(params[:id])
  end
  
  def new
    @menu = Menu.new
  end
  
  def edit
    @menu = @restaurant.find_menu(params[:id])
    @dish = Dish.new
    @menu_json = @menu.menu_to_json
  end
  
  def create
    @menu = Menu.new(params[:menu])
    if @menu.save
      redirect_to menus_path
    else
      raise 'menu did not save'
    end
  end
  
  def from_gwt
    raise params.inspect
  end
  
  def pages_layout
    request[:action] == 'edit' || request[:action] == 'index' ? 'admin' : choose_layout
  end
  
end