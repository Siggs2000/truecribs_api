class Api::V1::QuestionsController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    @question = Question.where("game_id = ? AND quest_num = ?", params[:game_id], params[:quest_num]).last
    render json: {success:true, result:@question}
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
