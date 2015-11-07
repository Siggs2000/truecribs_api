class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :game
  has_many :guesses


  def get_first_listing(location,vendor,game_id)
    # get first listing
    # create a question
    # create an answer

    @location = location
    options = {
      :status => "Active",
      :near => "#{location}",
      :radius => 30
    }
    response = HTTParty.get("https://rets.io/api/v1/#{vendor}/listings?access_token=#{ENV['server_token']}", query:options)
    response = response.to_hash['bundle']
    count = response.count
    number_choice = rand(count -1)
    chosen_listing = response[number_choice]
    @hood_name = chosen_listing['subdivision']
    @chosen_mls_num = chosen_listing['mlsListingID']
    @image_url = chosen_listing['media'].first['url']
    @price = chosen_listing['price']

    create_neighborhood_question(@image_url,game_id)

  end

  def create_neighborhood_question(image,game_id)
    question = Question.create!(game_id:game_id,
          body:"What neighborhood is this listing in?",
          image_url:image)
    create_correct_answer(@hood_name,question.id)
    get_other_listings(@price, @hood_name, question.id)
  end

  def create_correct_answer(hood_name,question_id)
    Answer.create!(correct:true, body:@hood_name, question_id:question_id)
  end

  def get_other_listings(price, subdivision, question_id)
    low_price = (price - (price*0.1))
    high_price = (price + (price*0.1))

    options = {
      :status => "Active",
      :near => "#{@location}",
      :radius => 30,
    }

    response = HTTParty.get("https://rets.io/api/v1/armls/listings?access_token=#{ENV['server_token']}&subdivision[ne]=#{@hood_name}&price[lt]=#{high_price}&price[gt]=#{low_price}", query:options)
    response = response.to_hash['bundle']
    count = response.count
    first_listing = response[0]
    choice_1 = first_listing['subdivision']

                                                                                                                    # &and.0.zoning.ne=C-1&and.1.zoning.ne=PUD
    response = HTTParty.get("https://rets.io/api/v1/armls/listings?access_token=#{ENV['server_token']}&and.0.subdivision.ne=#{@hood_name}&and.1.subdivision.ne=#{choice_1}&price[lt]=#{high_price}&price[gt]=#{low_price}", query:options)
    response = response.to_hash['bundle']
    count = response.count
    second_listing = response[0]
    choice_2 = second_listing['subdivision']

    response = HTTParty.get("https://rets.io/api/v1/armls/listings?access_token=#{ENV['server_token']}&and.0.subdivision.ne=#{@hood_name}&and.1.subdivision.ne=#{choice_1}&and.2.subdivision.ne=#{choice_2}&price[lt]=#{high_price}&price[gt]=#{low_price}", query:options)
    response = response.to_hash['bundle']
    count = response.count
    third_listing = response[0]
    choice_3 = third_listing['subdivision']

    create_wrong_answers(question_id, choice_1, choice_2, choice_3)
  end

  def create_wrong_answers(question_id, choice_1, choice_2, choice_3)
    Answer.create!(correct:false, body:choice_1, question_id:question_id)
    Answer.create!(correct:false, body:choice_2, question_id:question_id)
    Answer.create!(correct:false, body:choice_3, question_id:question_id)
  end

end
