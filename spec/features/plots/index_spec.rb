require 'rails_helper'

RSpec.describe 'Plots Index Page' do
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

  it 'when visiting the plots index page, I see a list of all plot numbers' do
    visit plots_path
    within "#plots" do
      expect(page).to have_content(@plot1.number)
      expect(page).to have_content(@plot2.number)
      expect(page).to have_content(@plot3.number)
      expect(page).to have_content(@plot4.number)
    end
  end

  it 'when I visit the plots index page, I see under each plot number, names of all that plot plants' do
    visit plots_path
    within "#plots" do
      expect(page).to have_content("Plants for #{@plot1.id}: Tomato Remove #{@plot1.id} Tomato Cucumber Remove #{@plot1.id} Cucumber Carrot Remove #{@plot1.id} Carrot Pepper Remove #{@plot1.id} Pepper")
      expect(page).to have_content("Plants for #{@plot2.id}: Tomato Remove #{@plot2.id} Tomato Cucumber Remove #{@plot2.id} Cucumber Carrot Remove #{@plot2.id} Carrot")
      expect(page).to have_content("Plants for #{@plot3.id}: Tomato Remove #{@plot3.id} Tomato Cucumber Remove #{@plot3.id} Cucumber")
      expect(page).to have_content("Plants for #{@plot4.id}: Tomato Remove #{@plot4.id} Tomato")
    end
  end

  it 'when in the plots index page, next to each plant name, I see a link to remove that plant from that plot' do
    visit plots_path
    within "#plots" do
      expect(page).to have_link("Remove #{@plot1.id} #{@plant1.name}")
      expect(page).to have_link("Remove #{@plot1.id} #{@plant2.name}")
      expect(page).to have_link("Remove #{@plot1.id} #{@plant3.name}")
      expect(page).to have_link("Remove #{@plot1.id} #{@plant4.name}")
      expect(page).to have_link("Remove #{@plot2.id} #{@plant1.name}")
      expect(page).to have_link("Remove #{@plot2.id} #{@plant2.name}")
      expect(page).to have_link("Remove #{@plot2.id} #{@plant3.name}")
      expect(page).to have_link("Remove #{@plot3.id} #{@plant1.name}")
      expect(page).to have_link("Remove #{@plot3.id} #{@plant2.name}")
      expect(page).to have_link("Remove #{@plot4.id} #{@plant1.name}")
    end
  end

  it 'when I click on the remove plant link, I am returned to the plots index page, and I no longer see that plant listed under that plot' do
    visit plots_path
    within "#plots" do
      expect(page).to have_content(@plant1.name)
      expect(page).to have_content(@plant2.name)
      expect(page).to have_content(@plant3.name)
      expect(page).to have_content(@plant4.name)
    end
    click_link("Remove #{@plot2.id} #{@plant1.name}")
    expect(current_path).to eq(plots_path)

    within "#plots" do
      expect(page).to_not have_content("Plants for #{@plot2.id}: Tomato Remove #{@plot2.id} Tomato Cucumber Remove #{@plot2.id} Cucumber Carrot Remove #{@plot2.id} Carrot")
    end
  end

  it 'when I visit the plots index page, and I have deleted a plant, I still see it in other plots' do
    visit plots_path
    within "#plots" do
      expect(page).to have_content(@plant1.name)
      expect(page).to have_content(@plant2.name)
      expect(page).to have_content(@plant3.name)
      expect(page).to have_content(@plant4.name)
    end

    click_link("Remove #{@plot2.id} #{@plant1.name}")
    expect(current_path).to eq(plots_path)

    within "#plots" do
      # I should no longer see tomato in plot 2
      expect(page).to_not have_content("Plants for #{@plot2.id}: Tomato Remove #{@plot2.id} Tomato Cucumber Remove #{@plot2.id} Cucumber Carrot Remove #{@plot2.id} Carrot")
      # I should still see tomato in plots 1, 3, and 4
      expect(page).to have_content("Plants for #{@plot1.id}: Tomato Remove #{@plot1.id} Tomato Cucumber Remove #{@plot1.id} Cucumber Carrot Remove #{@plot1.id} Carrot Pepper Remove #{@plot1.id} Pepper")
      expect(page).to have_content("Plants for #{@plot3.id}: Tomato Remove #{@plot3.id} Tomato Cucumber Remove #{@plot3.id} Cucumber")
      expect(page).to have_content("Plants for #{@plot4.id}: Tomato Remove #{@plot4.id} Tomato")
    end
  end
end