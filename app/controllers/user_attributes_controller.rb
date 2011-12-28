class UserAttributesController < ApplicationController
  def bookmarks
    respond_to do |format|
      format.json  { render :json => current_user.bookmarks_data }
    end
  end

  def profile
    respond_to do |format|
      format.json  { render :json => current_user.profile }
    end
  end

  # PUT /users/update
  def update
    user = User.where(authentication_token: params['auth_token']).first

    respond_to do |format|
      if user.blank?
        format.json { render :json => {:status => :not_found} }
      elsif user.update_without_password(params[:user])
        format.json { render :json => user, :status => 200 }
      else
        format.json { render :json => user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /users/attributes
  def attributes
    respond_to do |format|
      if current_user.present?
        format.json { render :json => current_user }
      else
        format.json { render :json => {:status => :not_found} }
      end
    end
  end
end
