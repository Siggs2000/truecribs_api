class Game < ActiveRecord::Base
  has_many :users
  has_many :questions


  def build_neighborhood_question(vendor)
    # Create a quesion
    # get a listing, save it's neigbhorhood and image URL
    # Find it's neighborhood
    # Find a few more listings in similar price range to get 3 other neighborhood names
    # Update  the question to include the image of the listing
    # Create four answers (3 with 3 decoy names and 1 with the correct name)

    if vendor == "armls"
      @location = "Phoenix"
    end

    Question.new.get_first_listing(@location,vendor,self.id)
  end

  def build_which_listing_question(vendor)
    if vendor == "armls"
      @location = "Phoenix"
    end
    Question.new.get_listing_question_listings(@location,vendor,self.id)
  end
end
