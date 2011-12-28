class PicturesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  skip_before_filter :verify_authenticity_token
  load_and_authorize_resource
  include Commentable

  # GET /pictures/new
  def new
    @picture = Picture.new

    respond_to do |format|
      format.html
      format.json { render :json => @picture.application_hash }
    end
  end

  # GET /pictures/1
  def show
    @picture = Picture.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render :json => @picture.application_hash(current_user) }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
  end

  # POST /pictures
  def create
    params[:picture].merge!(:user => current_user)
    @picture = Picture.new(params[:picture])

    respond_to do |format|
      if @picture.save
        format.html { redirect_to(@picture, :notice => 'Picture was successfully uploaded.') }
        format.json { render :json => @picture.application_hash(current_user), :status => :created, :location => @picture }
      else
        format.html { render :action => 'new' }
        format.json { render :json => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pictures/1
  def update
    @picture = Picture.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html { redirect_to(@picture, :notice => 'Picture was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => 'edit' }
        format.json { render :json => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /pictures
  def index
    @pictures = Picture.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @pictures.map(&:application_hash) }
    end
  end

  # DELETE /pictures/1
  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to(pictures_url) }
      format.json { head :ok }
    end
  end
end
