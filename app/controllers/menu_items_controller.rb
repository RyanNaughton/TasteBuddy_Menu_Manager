class MenuItemsController < ApplicationController
  before_filter :authenticate_user!, :only => [:rate]
  load_and_authorize_resource
  include CSVExportable
  include Ratable
  include Commentable
  include Taggable
  include Bookmarkable

  # GET /menu_items
  # GET /menu_items.xml
  def index
    if params[:restaurant_id]
      @restaurant = Restaurant.find(params[:restaurant_id])
      @menu_items = MenuItem.where(:restaurant_id => params[:restaurant_id]).all
    else
      @menu_items = MenuItem.all
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /menu_items/1
  # GET /menu_items/1.xml
  def show
    @menu_item = MenuItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @menu_item.application_hash(current_user).to_json }
    end
  end

  # GET /menu_items/new
  # GET /menu_items/new.xml
  def new
    @menu_item = MenuItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @menu_item }
    end
  end

  # GET /menu_items/1/edit
  def edit
    @menu_item = MenuItem.find(params[:id])
  end

  # POST /menu_items
  # POST /menu_items.xml
  def create
    @menu_item = MenuItem.new(params[:menu_item])

    respond_to do |format|
      if @menu_item.save
        format.html { redirect_to(@menu_item, :notice => 'Menu item was successfully created.') }
        format.xml  { render :xml => @menu_item, :status => :created, :location => @menu_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @menu_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /menu_items/1
  # PUT /menu_items/1.xml
  def update
    @menu_item = MenuItem.find(params[:id])

    respond_to do |format|
      if @menu_item.update_attributes(params[:menu_item])
        format.html { redirect_to(@menu_item, :notice => 'Menu item was successfully updated.') }
        format.xml  { head :ok }
        format.json { render :json => { :status => :ok }.to_json }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @menu_item.errors, :status => :unprocessable_entity }
        format.json { fail }
      end
    end
  end

  # DELETE /menu_items/1
  # DELETE /menu_items/1.xml
  def destroy
    @menu_item = MenuItem.find(params[:id])
    @menu_item.destroy

    respond_to do |format|
      format.html { redirect_to(menu_items_url) }
      format.xml  { head :ok }
    end
  end
end
