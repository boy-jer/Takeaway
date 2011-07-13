class DishesController < ApplicationController
  def create
    dish = Dish.new(params[:dish])
    if dish.save
      redirect_to edit_menu_path(dish.menu)
    else
      raise 'dish did not save'
    end
  end
end