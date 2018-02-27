class ApplicationController < ActionControl
}        e_action :otp_required_check, if: -> { OTP_ENABLED }
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
  add_flash_types :success, :warning, :info

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore
    respond_to do |format|
      format.html do 
          flash[:error] = t "policy.#{exception.query}", scope: 'pundit', default: :default
      redirect_to(request.referrer || root_path) end
      format.json { render json: { error: I18n.t('not_authorized') }, status: 403 }
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:otp_attempt])
  end

  def otp_required_check
    if current_user && current_user.otp_required_for_login == false
      redirect_to show_totp_qr_path, notice: 'Доступ без токена запрещен'
    end
  end
end
