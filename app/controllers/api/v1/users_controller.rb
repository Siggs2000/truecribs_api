class Api::V1::UsersController < ApplicationController

  # GET /user/1
  # GET /user/1.json
  def show
    @user = User.find(params[:id])
    render json: {sucess:true, result:@user}
  end


  private

  def user_params
    params.permit(:name, :email)
  end



  protected

end
