class ApplicationController < ActionController::Base
  include ApplicationHelper
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
end
