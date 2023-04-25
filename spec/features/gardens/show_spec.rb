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

    # These plants are not included in any specific plot
    # See the PlotPlant.create! calls below
    # So we should not see them in a list of plants under 100 days to harvest
    # I have also made sure that there are both over and under a hundred days to harvest
    # For the sake of testing robustness
    @plant5 = Plant.create!(name: "Watermellon", description: "Green", days_to_harvest: 90)
    @plant6 = Plant.create!(name: "Corn", description: "Yellow", days_to_harvest: 200)
    @plant7 = Plant.create!(name: "Apple", description: "Red", days_to_harvest: 100)
    @plant8 = Plant.create!(name: "Orange", description: "Orange", days_to_harvest: 150)

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
    # These plants are part of the garden's plots and take under 100 days to harvest
    # The ones we expect to see
    expect(page).to have_content(@plant1.name)
    expect(page).to have_content(@plant2.name)

    # These plants are part of the garden's plots but take over 100 days to harvest
    expect(page).to_not have_content(@plant3.name)
    expect(page).to_not have_content(@plant4.name)

    # These plants are not part of any garden's plots, so they should not be included in the list
    expect(page).to_not have_content(@plant5.name)
    expect(page).to_not have_content(@plant6.name)
    expect(page).to_not have_content(@plant7.name)
    expect(page).to_not have_content(@plant8.name)
  end

  it 'to further prove that the page is working correctly' do
    @plant9 = Plant.create!(name: "Strawberry", description: "Red", days_to_harvest: 90)
    @plant10 = Plant.create!(name: "Blueberry", description: "Blue", days_to_harvest: 198)

    PlotPlant.create!(plot: @plot1, plant: @plant9)
    PlotPlant.create!(plot: @plot2, plant: @plant10)

    visit garden_path(@garden1)

    expect(page).to have_content(@plant1.name)
    expect(page).to have_content(@plant2.name)
    expect(page).to have_content(@plant9.name) # new plant created above

    # These plants are part of the garden's plots but take over 100 days to harvest
    expect(page).to_not have_content(@plant3.name)
    expect(page).to_not have_content(@plant4.name)
    expect(page).to_not have_content(@plant10.name) # new plant created above

    # These plants are not part of any garden's plots, so they should not be included in the list
    expect(page).to_not have_content(@plant5.name)
    expect(page).to_not have_content(@plant6.name)
    expect(page).to_not have_content(@plant7.name)
    expect(page).to_not have_content(@plant8.name)
  end

  it 'when in the garden show page, I see that this list is unique' do 
    visit garden_path(@garden1)
    expect(page).to have_content(@plant1.name, count: 1)
    expect(page).to have_content(@plant2.name, count: 1)
  end
end