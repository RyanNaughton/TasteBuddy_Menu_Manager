module Commentable
  def comment
    @comment = Comment.new(
      :text => params[:text],
      :username => current_user.username,
      :user_id => current_user.id
    )

    obj = model.find(params[:id])
    obj.comments << @comment

    respond_to do |format|
      if obj.save
        format.json  { render :json => @comment, :status => :created }
      else
        format.json  { render :json => @comment.errors, :status => :unprocessable_entity }
      end
    end
  end
end
