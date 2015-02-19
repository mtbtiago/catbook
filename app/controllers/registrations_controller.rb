class RegistrationsController < ApplicationController
  def new
    @cat = Cat.new
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      # delayed
      #CatMailer.delay(run_at: 1.minute.from_now).welcome(@cat)
      # same thread
      CatMailer.welcome(@cat)

      redirect_to cats_path
    else
      render :new
    end
  rescue ActiveRecord::RecordNotUnique
    @cat.errors.add(:email, "There is already a user with this email")

    render :new
  end

  private

  def cat_params
    params.require(:cat).permit(:name, :email, :password, :password_confirmation)
  end
end
