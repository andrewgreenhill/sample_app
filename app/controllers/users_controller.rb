class UsersController < ApplicationController
  def show
  	@user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])
    if @user.save
    	sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
		else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #Handle a successful update:
      flash[:success] = "Profile updated"
      sign_in @user #Done because the remember token gets reset when the user is saved
      redirect_to @user
    else
      #Handle failed update attempt:
      render 'edit'
    end
  end

end
