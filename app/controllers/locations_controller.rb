class LocationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @locations = Location.all
    respond_with(@locations)
  end

  def show
    respond_with(@location)
  end

  def new
    @location = Location.new
    respond_with(@location)
  end

  def edit
  end

  def create
    @location = Location.new(location_params)
    @location.save
    respond_with(@location)
  end

  def update
    if to_bool(location_params.fetch(:is_current))
      @location.game.locations.update_all(is_current: false)
      @location.spawn_pcs_together
      @location.select_current_character!
    end

    @location.update(location_params)
    respond_with(@location.game)
  end

  def destroy
    @location.destroy
    respond_with(@location)
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:is_current)
  end
end

