class Api::V1::GamesController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    @game = Game.new(game_params)


    if @game.save
      render json: {success:true, result:@game}
    else
      render json: {success:true, result:@game}
    end
  end

  def index
    @game = Game.where(status:"active")
    render json: {success:true, result:@game}
  end

  def join_game
    @game = Game.find(params[:game_id])
    User.find(params[:user_id]).update(game_id:params[:game_id], score:0)
    render json: {sucess:true}
  end

  def show
    @game = Game.find(params[:id])
    render json: {success:true, result:@game}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_params
      params.permit(:name, :location, :winner, :stage, :status)
    end
end
