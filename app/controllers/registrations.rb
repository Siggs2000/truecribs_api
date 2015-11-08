class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :verify_authenticity_token,
                     :if => Proc.new { |c| c.request.format == 'application/json' }

  respond_to :json

  private

  def account_update_params
    params.require(:user).permit( :email, :password, :password_confirmation, :current_password)
  end

  def sign_up_params
    params.require(:user).permit( :email, :password, :password_confirmation, :authentication_token, :name)
  end
end
