class ProfilesController < ApplicationController
  before_action :set_profile

  def show
    @agents = current_user.agents.order(name: :asc)
                .page(params[:page]).per(12)
  end

  def edit
  end

  def update
    password = user_params[:password]

    if password.blank?
      data = user_without_password_params
    elsif @profile.valid_password? password
      data = user_without_password_params
    else
      data = user_params
    end

    if @profile.update(data)
      bypass_sign_in(@profile)
      redirect_to edit_profile_path
    else
      render 'edit'
    end
  end

  def confirm_destroy
    render partial: 'confirm_destroy', locals: { profile: @profile }
  end

  def destroy
    if @profile.destroy
      redirect_to unauthenticated_root_path, notice: t('views.profile.confirm_destroy.success_message')
    else
      redirect_to edit_profile_path, alert: t(
        'views.profile.confirm_destroy.errors_message',
        errors: @profile.errors.full_messages.join(', ')
      )
    end
  end

  def stop_impersonating
    stop_impersonating_user
    cookies.delete :impersonated_user_id # Needed for ActionCable
    redirect_to "/", notice: t('views.profile.stop_switch.success_message')
  end


  private

    def set_profile
      @profile = current_user
    end

    def user_params
      params.require(:profile).permit(:email, :password, :name, :username, :bio, :image, :remove_image)
    end

    def user_without_password_params
      params.require(:profile).permit(:email, :name, :username, :bio, :image, :remove_image)
    end

end
