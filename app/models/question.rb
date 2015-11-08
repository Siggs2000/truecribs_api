class Question < ActiveRecord::Base
  has_many :answers
  belongs_to :game
  has_many :guesses

  #### Begin Neighborhood Question
  def get_first_listing(location,vendor,game_id)
    # get first listing
    # create a question
    # create an answer

    @vendor = vendor
    @game_id = game_id
    @location = location
    options = {
      :status => "Active",
      :near => "#{location}",
      :radius => 30
    }
    response = HTTParty.get("https://rets.io/api/v1/#{vendor}/listings?access_token=#{ENV['server_token']}&subtype=Single%20Family%20Residence&price[gt]=200000&media[ne]=null", query:options)
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
          body:"Which neighborhood is this listing in?",
          image_url:image, quest_num:1)
    create_correct_answer(@hood_name,question.id)
    get_other_listings(@price, @hood_name, question.id)
  end

  def create_correct_answer(hood_name,question_id)
    Answer.create!(correct:true, body:@hood_name, question_id:question_id, mls_num:@chosen_mls_num)
  end

  def get_other_listings(price, subdivision, question_id)
    low_price = (price - (price*0.1))
    high_price = (price + (price*0.1))

    options = {
      :status => "Active",
      :near => "#{@location}",
      :radius => 100,
    }

    @url_hood = URI.escape("#{@hood_name}")
    response = HTTParty.get("https://rets.io/api/v1/#{@vendor}/listings?access_token=#{ENV['server_token']}&subdivision[ne]=#{@url_hood}&price[lt]=#{high_price}&price[gt]=#{low_price}&subtype=Single%20Family%20Residence", query:options)
    response = response.to_hash['bundle']
    count = response.count
    first_listing = response[0]
    choice_1 = first_listing['subdivision']
    @choice_1_mls_num = first_listing['mlsListingID']

    @url_choice_1 = URI.escape("#{choice_1}")                                                                                                             # &and.0.zoning.ne=C-1&and.1.zoning.ne=PUD
    response = HTTParty.get("https://rets.io/api/v1/#{@vendor}/listings?access_token=#{ENV['server_token']}&and.0.subdivision.ne=#{@url_hood}&and.1.subdivision.ne=#{@url_choice_1}&price[lt]=#{high_price}&price[gt]=#{low_price}&subtype=Single%20Family%20Residence", query:options)
    response = response.to_hash['bundle']
    count = response.count
    second_listing = response[0]
    choice_2 = second_listing['subdivision']
    @choice_2_mls_num = second_listing['mlsListingID']

    @url_choice_2 = URI.escape("#{choice_2}")
    response = HTTParty.get("https://rets.io/api/v1/#{@vendor}/listings?access_token=#{ENV['server_token']}&and.0.subdivision.ne=#{@url_hood}&and.1.subdivision.ne=#{@url_choice_1}&and.2.subdivision.ne=#{@url_choice_2}&price[lt]=#{high_price}&price[gt]=#{low_price}&subtype=Single%20Family%20Residence", query:options)
    response = response.to_hash['bundle']
    count = response.count
    third_listing = response[0]
    choice_3 = third_listing['subdivision']
    @choice_3_mls_num = third_listing['mlsListingID']

    create_wrong_answers(question_id, choice_1, choice_2, choice_3)
  end

  def create_wrong_answers(question_id, choice_1, choice_2, choice_3)
    Answer.create!(correct:false, body:choice_1, question_id:question_id, mls_num:@choice_1_mls_num )
    Answer.create!(correct:false, body:choice_2, question_id:question_id, mls_num:@choice_2_mls_num )
    Answer.create!(correct:false, body:choice_3, question_id:question_id, mls_num:@choice_3_mls_num )

    get_listing_question_listings(@location,@vendor,@game_id)
  end
  #### End neighborhood question





  #### Begin which listing is priced at $xxxx question
  def get_listing_question_listings(location,vendor,game_id)
    # get first listing
    # create a question
    # create an answer

    @location = location
    options = {
      :status => "Active",
      :near => "#{location}",
      :radius => 10
    }
    response = HTTParty.get("https://rets.io/api/v1/#{vendor}/listings?access_token=#{ENV['server_token']}&subtype=Single%20Family%20Residence&price[gt]=300000&media[ne]=null", query:options)
    response = response.to_hash['bundle']
    count = response.count
    number_choice = rand(count -1)
    chosen_listing = response[number_choice]
    @hood_name = chosen_listing['subdivision']
    @chosen_mls_num = chosen_listing['mlsListingID']
    @image_url = chosen_listing['media'].first['url']
    @price = chosen_listing['price']
    @address = chosen_listing['address']
    @num_beds = chosen_listing['bedrooms']
    @mls_num = chosen_listing['mlsListingID']

    create_which_price_question(@image_url, @price, game_id, vendor)
  end

  def create_which_price_question(image_url,price,game_id, vendor)
    question = Question.create!(game_id:game_id, quest_num:2,
          body:"Which of these listings are listed for #{ActionController::Base.helpers.number_to_currency(price, precision: 0)}?")
    create_correct_answer_two(image_url,question.id)
    get_other_listings_two(price, @hood_name, question.id, vendor)
  end

  def create_correct_answer_two(image_url,question_id)
    Answer.create!(correct:true, body:"#{@num_beds} Bedrooms in #{@hood_name}", question_id:question_id, image:@image_url, mls_num:@mls_num)
  end

  def get_other_listings_two(price, hood_name, question_id, vendor)
    options = {
      :status => "Active",
      :near => "#{@location}",
      :radius => 10
    }
    response = HTTParty.get("https://rets.io/api/v1/#{vendor}/listings?access_token=#{ENV['server_token']}&subtype=Single%20Family%20Residence&mlsListingID[ne]=#{@mls_num}&media[ne]=null", query:options)
    response = response.to_hash['bundle']
    count = response.count

    chosen_listing_one = response[0]
    @hood_name_one = chosen_listing_one['subdivision']
    @chosen_mls_num_one = chosen_listing_one['mlsListingID']
    @image_url_one = chosen_listing_one['media'].first['url']
    @num_beds_one = chosen_listing_one['bedrooms']
    body_1 = "#{@num_beds_one} Bedrooms in #{@hood_name_one}"
    image_1 = @image_url_one

    chosen_listing_two = response[1]
    @hood_name_two = chosen_listing_two['subdivision']
    @chosen_mls_num_two = chosen_listing_two['mlsListingID']
    @image_url_two = chosen_listing_two['media'].first['url']
    @num_beds_two = chosen_listing_two['bedrooms']
    body_2 = "#{@num_beds_two} Bedrooms in #{@hood_name_two}"
    image_2 = @image_url_two

    chosen_listing_three = response[2]
    @hood_name_three = chosen_listing_three['subdivision']
    @chosen_mls_num_three = chosen_listing_three['mlsListingID']
    @image_url_three = chosen_listing_three['media'].first['url']
    @num_beds_three = chosen_listing_three['bedrooms']
    body_3 = "#{@num_beds_three} Bedrooms in #{@hood_name_three}"
    image_3 = @image_url_three

    create_wrong_answers_two(question_id, body_1, body_2, body_3, image_1, image_2, image_3)
  end

  def create_wrong_answers_two(question_id, body_1, body_2, body_3, image_1, image_2, image_3)
    Answer.create!(correct:false, body:body_1, question_id:question_id, image:image_1, mls_num:@chosen_mls_num_one)
    Answer.create!(correct:false, body:body_2, question_id:question_id, image:image_2, mls_num:@chosen_mls_num_two)
    Answer.create!(correct:false, body:body_3, question_id:question_id, image:image_3, mls_num:@chosen_mls_num_three)

    get_sold_question_listings(@location,@vendor,@game_id)
  end
  #### End which listing is priced at $xxxx question





  #### Begin which listing was sold the fastest
  def get_sold_question_listings(location,vendor,game_id)
    # get first listing
    # create a question
    # create an answer

    @location = location
    options = {
      :status => "Closed",
      :near => "#{location}",
      :radius => 10
    }
    response = HTTParty.get("https://rets.io/api/v1/#{vendor}/listings?access_token=#{ENV['server_token']}&subtype=Single%20Family%20Residence&daysOnMarket[lt]=30&price[gt]=200000", query:options)
    response = response.to_hash['bundle']
    count = response.count
    number_choice = rand(count -1)
    chosen_listing = response[number_choice]
    @hood_name = chosen_listing['subdivision']
    @chosen_mls_num = chosen_listing['mlsListingID']
    @image_url = nil #chosen_listing['media'].first['url']
    @price = chosen_listing['price']
    @address = chosen_listing['address']
    @num_beds = chosen_listing['bedrooms']
    @mls_num = chosen_listing['mlsListingID']
    @dom = chosen_listing['daysOnMarket']

    create_which_dom_question(@image_url, @price, game_id, vendor)
  end

  def create_which_dom_question(image_url,price,game_id, vendor)
    question = Question.create!(game_id:game_id, quest_num:3,
          body:"Which of these listings sold the fastest?")
    create_correct_answer_three(image_url,question.id)
    get_other_listings_three(price, @hood_name, question.id, vendor)
  end

  def create_correct_answer_three(image_url,question_id)
    Answer.create!(correct:true, body:"#{@num_beds} Bedrooms in #{@hood_name} for #{ActionController::Base.helpers.number_to_currency(@price, precision: 0)}", question_id:question_id, mls_num:@mls_num)
  end

  def get_other_listings_three(price, hood_name, question_id, vendor)
    options = {
      :status => "Closed",
      :near => "#{@location}",
      :radius => 10
    }
    response = HTTParty.get("https://rets.io/api/v1/#{vendor}/listings?access_token=#{ENV['server_token']}&subtype=Single%20Family%20Residence&daysOnMarket[gt]=30&price[gt]=200000", query:options)
    response = response.to_hash['bundle']
    count = response.count

    chosen_listing_one = response[0]
    @hood_name_one = chosen_listing_one['subdivision']
    @chosen_mls_num_one = chosen_listing_one['mlsListingID']
    @image_url_one = nil#chosen_listing_one['media'].first['url']
    @num_beds_one = chosen_listing_one['bedrooms']
    @dom_one = chosen_listing_one['daysOnMarket']
    @price_one = chosen_listing_one['price']
    body_1 = "#{@num_beds_one} Bedrooms in #{@hood_name_one} for #{ActionController::Base.helpers.number_to_currency(@price_one, precision: 0)}"
    image_1 = @image_url_one

    chosen_listing_two = response[1]
    @hood_name_two = chosen_listing_two['subdivision']
    @chosen_mls_num_two = chosen_listing_two['mlsListingID']
    @image_url_two = nil#chosen_listing_two['media'].first['url']
    @num_beds_two = chosen_listing_two['bedrooms']
    @dom_two = chosen_listing_two['daysOnMarket']
    @price_two = chosen_listing_two['price']
    body_2 = "#{@num_beds_two} Bedrooms in #{@hood_name_two} for #{ActionController::Base.helpers.number_to_currency(@price_two, precision: 0)}"
    image_2 = @image_url_two

    chosen_listing_three = response[2]
    @hood_name_three = chosen_listing_three['subdivision']
    @chosen_mls_num_three = chosen_listing_three['mlsListingID']
    @image_url_three = nil#chosen_listing_three['media'].first['url']
    @num_beds_three = chosen_listing_three['bedrooms']
    @dom_three = chosen_listing_three['daysOnMarket']
    @price_three = chosen_listing_three['price']
    body_3 = "#{@num_beds_three} Bedrooms in #{@hood_name_three} for #{ActionController::Base.helpers.number_to_currency(@price_three, precision: 0)}"
    image_3 = @image_url_three

    create_wrong_answers_three(question_id, body_1, body_2, body_3, image_1, image_2, image_3)
  end

  def create_wrong_answers_three(question_id, body_1, body_2, body_3, image_1, image_2, image_3)
    Answer.create!(correct:false, body:body_1, question_id:question_id, mls_num:@chosen_mls_num_one)
    Answer.create!(correct:false, body:body_2, question_id:question_id, mls_num:@chosen_mls_num_two)
    Answer.create!(correct:false, body:body_3, question_id:question_id, mls_num:@chosen_mls_num_three)
  end
  #### End which listing was sold in 2015
end
