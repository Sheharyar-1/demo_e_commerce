class UserController < ApplicationController
  def index; end
  def list
    @users =User.all
  end

  def new
    @user=User.new
  end

  def create
    @user=User.new(user_params)

    if @user.save
      redirect_to list_user_path
    else
      flash[:danger] = "Could not create a user."
      redirect_to list_user_path
    end
  end

  def edit
    @user=User.find(params[:id])
    
  end

  def update
    @user=User.find(params[:id])
    if @user.update(user_params)
      redirect_to list_user_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    
    @user = User.find(params[:id])
    @user.destroy
    flash[:notice] = "You have deleted the user."
    redirect_to list_user_path, status: :see_other
  end
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end
end
