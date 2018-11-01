class UsersController < ApplicationController
  before_action :signed_in_user,
                only: [:index, :edit, :update, :destroy]
  before_action :correct_user,      only: [:show, :edit, :update]
  before_action :admin_user,        only: [:destroy]
  before_action :already_signed_in, only: [:new, :create]

  def add_card
    @card = Card.find_by(multiverseid: params[:card])
    current_user.add!(@card)
    respond_to do |format|
      format.js { render template: 'cards/add_remove', notice: "#{@card.name} added!" }
    end
  end

  def remove_card
    @card = Card.find_by(multiverseid: params[:card])
    current_user.remove!(@card)
    respond_to do |format|
      format.js { render template: 'cards/add_remove', notice: "#{@card.name} removed..." }
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @cards = @user.cards
  end

  def edit
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def index
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user) || current_user.try(:admin?)
    end

    def admin_user
      redirect_to(root_path) unless current_user.try(:admin?)
    end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
