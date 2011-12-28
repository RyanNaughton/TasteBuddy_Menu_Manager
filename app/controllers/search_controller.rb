class SearchController < ApplicationController
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
      elsif ! @near.match(/chicago/i)
        values_container['near'] = (@near.to_s << ' Chicago')
      end
    end

    @search = Search.create!(values_container.merge(user: current_user))
    @results = @search.results

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @results.map {|r| r.application_hash(current_user) }.to_json }
    end
  end
end
