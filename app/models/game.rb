class Game < ActiveRecord::Base
  has_many :users
  has_many :questions
  after_create :set_stage

  def build_questions(vendor)
    build_neighborhood_question(vendor)
  end

  def build_neighborhood_question(vendor)
    # Create a quesion
    # get a listing, save it's neigbhorhood and image URL
    # Find it's neighborhood
    # Find a few more listings in similar price range to get 3 other neighborhood names
    # Update  the question to include the image of the listing
    # Create four answers (3 with 3 decoy names and 1 with the correct name)

    if vendor == "armls"
      @location = "Phoenix"
    elsif vendor == "test_sd"
      @location = "San%20Diego"
    elsif vendor == "omreb"
      @location = "Okanagan"
    end

    Question.new.get_first_listing(@location,vendor,self.id)
  end

  def build_which_listing_question(vendor)
    if vendor == "armls"
      @location = "Phoenix"
    elsif vendor == "test_sd"
      @location = "San%20Diego"
    elsif vendor == "omreb"
      @location = "Okanagan"
    end
    Question.new.get_listing_question_listings(@location,vendor,self.id)
  end

  private

  def set_stage
    self.update(stage:1)
    #build_neighborhood_question("#{self.location}")
  end
end
