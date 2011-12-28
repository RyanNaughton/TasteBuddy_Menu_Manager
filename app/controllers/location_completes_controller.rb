class LocationCompletesController < ApplicationController
  # GET /search.html
  def new
    @search = Search.new

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # POST /location_complete
  # POST /location_complete.json
  def show
    values_container = params['search'] ? params['search'] : params
    @find, @near, @coordinates, @page = values_container.values_at('find', 'near', 'coordinates', 'page')

    if @near.present?
      if @near.include?('Current Location')
        values_container['near'] = @near = nil # Monkey patch
      elsif ! @near.match(/chicago/i)
        values_container['near'] = (@near.to_s << ' Chicago')
      end
    end

    @results = LocationFilter.new(@near).values

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @results }
    end
  end
end
