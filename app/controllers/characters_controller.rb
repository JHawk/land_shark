class CharactersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_character, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def random
    @character = Characters::Human.generate!
    respond_with(@character)
  end

  def index
    @characters = Character.all
    respond_with(@characters)
  end

  def show
    respond_with(@character)
  end

  def new
    @character = Character.new
    respond_with(@character)
  end

  def edit
  end

  def create
    @character = Character.new(character_params)
    @character.save
    respond_with(@character)
  end

  def update
    @character.update(character_params)
    respond_with(@character)
  end

  def destroy
    @character.destroy
    respond_with(@character)
  end

  private
    def set_character
      @character = Character.find(params[:id]) if params[:id]
    end

    def character_params
      params.require(:character).permit(:name, :strength, :dexterity, :constitution, :intelligence, :wisdom, :charisma)
    end
end
