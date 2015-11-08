class GamesController < ApplicationController

  def index
    @games = Game.where(status:"active")
  end

  def show
  end

  def new
    @game = Game.new(game_params)
  end

  def create
    @game = Game.create(game_params)
    @game.build_questions(@game.location)
    current_user.update(game_id:@game.id, score:0)
    first_question = Question.where(game_id:@game.id).first
    redirect_to question_path(first_question)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_game
      @game = Game.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def game_params
      unless params[:game].blank?
        params.require(:game).permit(:name, :location, :winner, :stage, :status)
      end
    end
end
