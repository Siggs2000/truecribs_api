class SessionsController < Devise::SessionsController
  protect_from_forgery with: :null_session
  
  def create
    resource = User.find_for_database_authentication(:email => params[:user][:email])


    return failure unless resource

    #if resource.valid_password?(params[:user][:password])
      p "password is valid"
      token = resource.generate_auth_token
      user = User.find_by(email:"#{params[:user][:email]}")
      user.update(authentication_token: token)
      sign_in(:user, resource)
      #resource.ensure_authentication_token!
      render :json => { :success => true,
                        :info => "Logged in",
                        :data => { :auth_token => token,
                                   :user_id => resource.id,
                                   :name => resource.name,
                                   :email => resource.email} }
      return
    #end
    #failure
 end #params[:provider]

 def failure(message)
   render :status => 401,
          :json => { :success => false,
                     :info => "Login Failed",
                     :data => {message: message} }
 end

 private

 def account_update_params
   params.require(:user).permit( :email, :password, :password_confirmation, :current_password)
 end

 def sign_up_params
   params.require(:user).permit( :email, :password, :password_confirmation, :name)
 end
end
