class Guess < ActiveRecord::Base
  belongs_to :user
  belongs_to :answer
  belongs_to :question

  after_create :grade_question




  protected

  def grade_question
    answer = Answer.find(self.answer_id)
    count = Guess.where(question_id:answer.question.id).count
    game = answer.question.game
    player_count = User.where(game_id:game.id).count
    if count == player_count
      # grade the qustion
      Guess.where(question_id:self.question_id).each do |guess|
        answer = Answer.find(guess.answer_id)
        if answer.correct?
          points = guess.user.points
          guess.user.update(score:points+50)
        end
      end #Guess.where
    end # if count ==
  end # grade_question
end
