class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include ApplicationHelper
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
end
