module Bookmarkable
  def add_bookmark
    obj = model.find(params[:id])
    obj.add_bookmark(current_user)
    current_user.add_bookmark(obj)

    respond_to do |format|
      if obj.save and current_user.save
        format.json  { render :json => {:status => :success} }
      else
        format.json  { render :json => {:status => :internal_server_error} }
      end
    end
  end

  def remove_bookmark
    obj = model.find(params[:id])
    obj.remove_bookmark(current_user)
    current_user.remove_bookmark(obj)

    respond_to do |format|
      if obj.save and current_user.save
        format.json  { render :json => {:status => :success} }
      else
        format.json  { render :json => {:status => :internal_server_error} }
      end
    end
  end
end
