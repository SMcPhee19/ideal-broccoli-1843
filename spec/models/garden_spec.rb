require 'rails_helper'

RSpec.describe Garden do
  describe 'relationships' do
    it { should have_many(:plots) }
    it { should have_many(:plants).through(:plots) }
  end

  describe 'class methods' do
    before(:each) do
      @garden1 = Garden.create!(name: "Jim's Garden", organic: true)
      @garden2 = Garden.create!(name: "Frank's Garden", organic: false)
  
      @plot1 = @garden1.plots.create!(number: 1, size: "Large", direction: "East")
      @plot2 = @garden1.plots.create!(number: 2, size: "Medium", direction: "West")
      @plot3 = @garden2.plots.create!(number: 3, size: "Small", direction: "East")
      @plot4 = @garden2.plots.create!(number: 4, size: "Large", direction: "South")
  
      @plant1 = Plant.create!(name: "Tomato", description: "Easy to grow", days_to_harvest: 90)
      @plant2 = Plant.create!(name: "Cucumber", description: "Hard to grow", days_to_harvest: 95)
      @plant3 = Plant.create!(name: "Carrot", description: "Easy to grow", days_to_harvest: 120)
      @plant4 = Plant.create!(name: "Pepper", description: "Hard to grow", days_to_harvest: 150)
  
      PlotPlant.create!(plot: @plot1, plant: @plant1)
      PlotPlant.create!(plot: @plot1, plant: @plant2)
      PlotPlant.create!(plot: @plot1, plant: @plant3)
      PlotPlant.create!(plot: @plot1, plant: @plant4)
  
      PlotPlant.create!(plot: @plot2, plant: @plant1)
      PlotPlant.create!(plot: @plot2, plant: @plant2)
      PlotPlant.create!(plot: @plot2, plant: @plant3)
  
      PlotPlant.create!(plot: @plot3, plant: @plant1)
      PlotPlant.create!(plot: @plot3, plant: @plant2)
  
      PlotPlant.create!(plot: @plot4, plant: @plant1)
    end

    it '#less_than_100_days' do
      expect(@garden1 .less_than_100_days.order(:id)).to eq([@plant1, @plant2])
      # I don't know if the .order(:id) is kosher here or not,
      # but the order of the plants in the array kept changing if I didn't add it here
    end
  end
end