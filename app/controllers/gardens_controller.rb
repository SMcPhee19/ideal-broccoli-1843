class GardensController < ApplicationController
  def show
    @garden = Garden.find(params[:id])
    @plants = @garden.less_than_100_days
  end
end