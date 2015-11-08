class QuestionsController < ApplicationController
  require 'timers'

  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # GET /questions
  def index
    @questions = Question.all
  end

  # GET /questions/1
  def show
    @question = Question.find(params[:id])
    @answers = Answer.where(question_id: @question.id)

    #while match == false
    check_sumbission
  end

  def check_sumbission
    game = @answers.first.question.game
    @player_count = User.where(game_id:game.id).count

    question_id = @answers.first.question.id
    @count = Guess.where(question_id:question_id).count

    p "COUNT IS: #{@count}"
    if @count == @player_count
      game.update(stage:2)
      next_question = (params[:id].to_i + 1)
      @next_question = Question.find(next_question)
      redirect_to question_path(@next_question)
    end
  end



  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions
  def create
    @question = Question.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /questions/1
  def update
    if @question.update(question_params)
      redirect_to @question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /questions/1
  def destroy
    @question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def question_params
      params.permit(:game_id, :body, :image_url, :quest_num, :image_url)
    end
end
