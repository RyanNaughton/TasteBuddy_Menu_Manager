module Ratable
  def rate
    obj = model.find(params[:id])
    obj.add_rating(current_user, params[:value])

    respond_to do |format|
      if obj.errors.empty? and obj.save and current_user.save
        format.json  { render :json => obj.application_hash(current_user) }
      else
        format.json  { render :json => obj.errors, :status => :unprocessable_entity }
      end
    end
  end
end
