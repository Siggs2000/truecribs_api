class Api::V1::GuessesController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    answer = Answer.find(params[:answer_id])
    @guess = Guess.new(answer_id:params[:answer_id], user_id:params[:user_id], question_id:answer.question_id)


    if @guess.save
      render json: {success:true, result:@guess}
    else
      render json: {success:true, result:@guess}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guess
      @guess = Guess.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def guess_params
      params.permit(:answer_id, :user_id, :question_id)
    end
end
