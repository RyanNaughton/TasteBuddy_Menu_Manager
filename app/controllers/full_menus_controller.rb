class FullMenusController < ApplicationController
  # GET /restaurants/1/menu
  def show
    restaurant = Restaurant.find(params[:id])
    menu = restaurant.application_menu

    respond_to do |format|
      format.json { render :json => menu.to_json }
      format.csv  { render :text => restaurant.csv_menu }
    end
  end
end
