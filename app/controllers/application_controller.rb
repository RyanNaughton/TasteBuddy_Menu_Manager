class ApplicationController < ActionController::Base
  protect_from_forgery

  def model
    self
      .class
      .name
      .sub('Controller', %q{})
      .singularize
      .constantize
  end
end
