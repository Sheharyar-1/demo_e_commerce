class HomeController < ApplicationController
  def index; end
  def list
    @users =User.all
  end
end
