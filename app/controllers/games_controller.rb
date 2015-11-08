class GamesController < ApplicationController

  def index
    @games = Game.where(status:"active")
  end

  def show
    @game = Game.find(params[:id])
    @first_question = @game.questions.first.id
    @first_answer = @game.questions.first.answers.first
    @second_answer = @game.questions.second.answers.first
    @third_answer = @game.questions.third.answers.first
    #@fourth_answer = @game.questions.fourth.answers.first

    @q1_guesses = Guess.where(question_id:@first_question)
    @q2_guesses = Guess.where(question_id:@first_question+1)
    @q3_guesses = Guess.where(question_id:@first_question+2)

    @users = User.where(game_id:@game.id)
  end

  def new
    @game = Game.new(game_params)
  end

  def create
    @game = Game.new(game_params)
    @game = Game.create(game_params)

    current_user.update(game_id:@game.id, score:0)
    @game.build_questions(@game.location)
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
