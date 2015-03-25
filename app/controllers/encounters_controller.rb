class EncountersController < ApplicationController
  before_action :set_encounter, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @encounters = Encounter.all
    respond_with(@encounters)
  end

  def show
    respond_with(@encounter)
  end

  def new
    @encounter = Encounter.new
    respond_with(@encounter)
  end

  def edit
  end

  def create
    @encounter = Encounter.new(encounter_params)
    @encounter.save
    respond_with(@encounter)
  end

  def update
    @encounter.update(encounter_params)
    respond_with(@encounter)
  end

  def destroy
    @encounter.destroy
    respond_with(@encounter)
  end

  private
    def set_encounter
      @encounter = Encounter.find(params[:id])
    end

    def encounter_params
      params.require(:encounter).permit(:completed)
    end
end
