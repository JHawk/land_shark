class OccupationsController < ApplicationController
  before_action :set_occupation, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @occupations = Occupation.all
    respond_with(@occupations)
  end

  def show
    respond_with(@occupation)
  end

  def new
    @occupation = Occupation.new
    respond_with(@occupation)
  end

  def edit
  end

  def create
    @occupation = Occupation.new(occupation_params)
    @occupation.save
    respond_with(@occupation)
  end

  def update
    @occupation.update(occupation_params)
    respond_with(@occupation)
  end

  def destroy
    @occupation.destroy
    respond_with(@occupation)
  end

  private
    def set_occupation
      @occupation = Occupation.find(params[:id])
    end

    def occupation_params
      params.require(:occupation).permit(:name)
    end
end
