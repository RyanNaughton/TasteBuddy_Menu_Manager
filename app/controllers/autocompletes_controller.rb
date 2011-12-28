class AutocompletesController < ApplicationController
  # GET /search.html
  def new
    @search = Search.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # POST /search
  # POST /search.json
  def show
    values_container = params['search'] ? params['search'] : params
    @find, @near, @coordinates, @page = values_container.values_at('find', 'near', 'coordinates', 'page')

    if @near.present?
      if @near.include?('Current Location')
        values_container['near'] = @near = nil # Monkey patch
      end
    end

    @search = Search.new(values_container.merge(user: current_user))
    @results = @search.autocomplete

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @results }
    end
  end
end
