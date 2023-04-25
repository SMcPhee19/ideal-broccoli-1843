require 'rails_helper'

RSpec.describe 'Garden Show Page' do
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

  it 'when in the garden show page, I see a list of plants that are included in that garden plots 
  that are under 100 days to harvest' do
    visit garden_path(@garden1)

    expect(page).to have_content(@plant1.name)
    expect(page).to have_content(@plant2.name)
    expect(page).to_not have_content(@plant3.name)
    expect(page).to_not have_content(@plant4.name)
  end

  it 'when in the garden show page, I see that this list is unique' do 
    visit garden_path(@garden1)
    save_and_open_page
    expect(page).to have_content(@plant1.name, count: 1)
    expect(page).to have_content(@plant2.name, count: 1)
  end
end