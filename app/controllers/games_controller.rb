class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @games = Game.all
    respond_with(@games)
  end

  def show
    respond_with(@game)
  end

  def new
    @game = Game.new
    respond_with(@game)
  end

  def edit
  end

  def create
    @game = Game.new(game_params)
    @game.user = current_user
    @game.save
    respond_with(@game)
  end

  def update
    @game.update(game_params)
    respond_with(@game)
  end

  def destroy
    @game.destroy
    respond_with(@game)
  end

  private
    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params[:game]
    end
end
