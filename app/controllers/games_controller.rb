class GamesController < ApplicationController

  def index
    @games = Game.where(status:"active")
  end

  def show
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
end
