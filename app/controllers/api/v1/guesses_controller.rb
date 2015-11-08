class Api::V1::GuessesController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    p params
    answer = Answer.find(params[:answer_id])
    @guess = Guess.new(answer_id:params[:answer_id], user_id:params[:user_id], question_id:answer.question_id)
    p @guess

    if @guess.save
      render json: {success:true, result:@guess}
      # # update the valuable feedback data
      # mls_num = @guess.answer.mls_num
      # p "MLS NUM IS #{mls_num}"
      # question_num = @guess.answer.question.quest_num
      # p "Question NUM IS #{question_num}"
      #
      # if Listing.where(mls_num:mls_num).count >= 1
      #   @listing = Listing.where(mls_num:mls_num).last
      #   if question_num == 1
      #     count = @listing.recognizable
      #     count = count + 1
      #     @listing.update(recognizable:count)
      #   elsif question_num == 2
      #     count = @listing.list_price_under
      #     count = count + 1
      #     @listing.update(list_price_under:count)
      #     Guess.where(answer_id:@guess.answer.id).each do |guess|
      #       unless guess.id == @guess.id
      #         if listing = Listing.where(mls_num:guess.mls_num).count >= 1
      #           count = @listing.list_price_over
      #           count = count + 1
      #           listing.update(list_price_over:count)
      #         else
      #           Listing.create!(mls_num:guess.mls_num, list_price_over:1)
      #         end # if
      #       end # unless
      #     end # Guess.where
      #   end # if question_num
      # else
      #   @listing = Listing.create!(mls_num:mls_num)
      #   if question_num == 1
      #     count = @listing.recognizable
      #     count = count + 1
      #     @listing.update(recognizable:count)
      #   elsif
      #     count = @listing.list_price_under
      #     count = count + 1
      #     @listing.update(list_price_under:count)
      #     Guess.where(answer_id:@guess.answer.id).each do |guess|
      #       unless guess.id == @guess.id
      #         if listing = Listing.where(mls_num:guess.mls_num).count >= 1
      #           count = @listing.list_price_over
      #           count = count + 1
      #           listing.update(list_price_over:count)
      #         else
      #           Listing.create!(mls_num:guess.mls_num, list_price_over:1)
      #         end # if
      #       end # unless
      #     end # Guess.where
      #   end
      # end # if Listing.where
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
