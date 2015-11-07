class GuessesController < ApplicationController
  before_action :set_guess, only: [:show, :edit, :update, :destroy]

  # GET /guesses
  def index
    @guesses = Guess.all
  end

  # GET /guesses/1
  def show
  end

  # GET /guesses/new
  def new
    @guess = Guess.new
  end

  # GET /guesses/1/edit
  def edit
  end

  # POST /guesses
  def create
    @guess = Guess.new(guess_params)

    if @guess.save
      redirect_to @guess, notice: 'Guess was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /guesses/1
  def update
    if @guess.update(guess_params)
      redirect_to @guess, notice: 'Guess was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /guesses/1
  def destroy
    @guess.destroy
    redirect_to guesses_url, notice: 'Guess was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guess
      @guess = Guess.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def guess_params
      params[:guess]
    end
end
