class MenusController < ApplicationController
  # GET /restaurants/1/menu_sections/1.json
  def show
    restaurant = Restaurant.find(params[:id])
    menu = restaurant.menu_section(params[:index].to_i)

    respond_to do |format|
      format.json { render :json => menu.to_json }
    end
  end
end
