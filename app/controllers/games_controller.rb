class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: [:next_event, :show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @games = Game.all
    respond_with(@games)
  end

  def show
    respond_to do |format|
      format.html { @game }
      format.json { @game }
    end
  end

  def next_event
    @game.generate_encounters!
    redirect_to(@game)
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
    character = Character.find params['character_id']

    tci = params['target_character_id']
    if tci && Character.find(tci)
      character.update_attributes!(target_character_id: tci)
    end

    if character.can?(params['game_action'])
      position = [params['x'], params['y'], params['z']].map(&:to_i)
      @game.move!(character, position, params['game_action'])
    else
      raise "#{character.name} can't #{params['game_action']}!"
    end

    respond_to do |format|
      format.html { @game }
      format.json { @game }
    end
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
