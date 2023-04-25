# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Garden.destroy_all
Plot.destroy_all
Plant.destroy_all
PlotPlant.destroy_all

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

