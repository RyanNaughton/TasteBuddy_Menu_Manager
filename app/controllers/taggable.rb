module Taggable
  def add_tag
    obj = model.find(params[:id])
    obj.add_tag(current_user, params[:value])

    respond_to do |format|
      if obj.errors.empty? and obj.save
        format.json { render :json => {user_tags: obj.user_tags(current_user), tags: obj.tags_with_count} }
      else
        format.json { render :json => obj.errors, :status => :unprocessable_entity }
      end
    end
  end

  def remove_tag
    obj = model.find(params[:id])
    obj.remove_tag(current_user, params[:value])

    respond_to do |format|
      if obj.errors.empty? and obj.save
        format.json { render :json => {user_tags: obj.user_tags(current_user), tags: obj.tags_with_count} }
      else
        format.json { render :json => obj.errors, :status => :unprocessable_entity }
      end
    end
  end
end
