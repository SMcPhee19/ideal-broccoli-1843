class Garden < ApplicationRecord
  has_many :plots
  has_many :plants, through: :plots

  # Old Method that was wrong
  # def less_than_100_days
  #   Plant.where('days_to_harvest < ?', 100).distinct
  # end

  # New method that is correct
  def less_than_100_days
    plants.where('days_to_harvest < ?', 100).distinct
  end
  # Insted of calling on `Plant`, which would explain why it was returning all plants(*facepalm* I knew I missed soemthing)
  # Since we are in the garden model, we can call `.plants`
  # Which should return only the plants in the garden
  # Because of the association set up in this model
end
