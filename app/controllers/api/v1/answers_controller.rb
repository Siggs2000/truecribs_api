class Api::V1::AnswersController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @answers = Answer.where(question_id:params[:question_id])
    render json: {success:true, result:@answers}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_params
      params.permit(:name, :location, :winner, :stage, :status, :quest_num)
    end
end
