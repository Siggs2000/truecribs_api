class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :game
  has_many :guesses

  def neighborhood_question(vendor)
    # Create a quesion
    # get a listing, save it's neigbhorhood and image URL
    # Find it's neighborhood
    # Find a few more listings in similar price range to get 3 other neighborhood names
    # Update  the question to include the image of the listing
    # Create four answers (3 with 3 decoy names and 1 with the correct name)

    if vendor == "armls"
      near = "Phoenix"
    end
  end

  def get_first_listing(location,vendor,game_id)
    # get first listing
    # create a question
    # create an answer
    options = {
      :status => "Active",
      :near => "#{location}",
      :radius => 30
    }
    response = HTTParty.get("https://rets.io/api/v1/#{vendor}/listings?access_token=2a1f5ffae087869723cc83e87be7ab63", query:options)
    response = response.to_hash['bundle']
    count = response.count
    number_choice = rand(count -1)
    chosen_listing = response[number_choice]
    @hood_name = chosen_listing['subdivision']
    @chosen_mls_num = chosen_listing['mlsListingID']
    @image_url = chosen_listing['media'].first['url']

    create_neighborhood_question(@image_url,game_id)
  end

  def create_neighborhood_question(image,game_id)
    question = Question.create!(game_id:game_id,
          body:"What neighborhood is this listing in?",
          image_url:image)
    create_correct_answer(@hood_name,question.id)
    get_other_listings
  end

  def create_correct_answer(hood_name,question_id)
    Answer.create!(correct:true, body:@hood_name)
  end

  def get_other_listings()

    create_wrong_answers(question_id)
  end

  def create_wrong_answers(question_id)

  end

end
