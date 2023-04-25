require 'rails_helper'

RSpec.describe Plot do
  describe 'relationships' do
    it { should belong_to(:garden) }
    it { should have_many(:plot_plants) }
    it { should have_many(:plants).through(:plot_plants) }
  end



  describe 'instance methods' do
    before(:each) do
      @garden1 = Garden.create!(name: "Jim's Garden", organic: true)
      @garden2 = Garden.create!(name: "Frank's Garden", organic: false)
  
      @plot1 = @garden1.plots.create!(number: 1, size: "Large", direction: "East")
      @plot2 = @garden1.plots.create!(number: 2, size: "Medium", direction: "West")
      @plot3 = @garden2.plots.create!(number: 3, size: "Small", direction: "East")
      @plot4 = @garden2.plots.create!(number: 4, size: "Large", direction: "South")
  
      @plant1 = Plant.create!(name: "Tomato", description: "Easy to grow", days_to_harvest: 90)
      @plant2 = Plant.create!(name: "Cucumber", description: "Hard to grow", days_to_harvest: 100)
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

    it '::all_plants' do
      expect(@plot1.all_plants).to eq([@plant1, @plant2, @plant3, @plant4])
      expect(@plot2.all_plants).to eq([@plant1, @plant2, @plant3])
      expect(@plot3.all_plants).to eq([@plant1, @plant2])
      expect(@plot4.all_plants).to eq([@plant1])
    end
  end
end
