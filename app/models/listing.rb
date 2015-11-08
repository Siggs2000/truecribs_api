class Listing < ActiveRecord::Base

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |listing|
        csv << listing.attributes.values_at(*column_names)
      end
    end
  end

  def get_details(mls_num,vendor)
    @vendor = vendor

    response = HTTParty.get("https://rets.io/api/v1/#{vendor}/listings?access_token=#{ENV['server_token']}&radius=30&mlsListingID=#{mls_num}")
    response = response.to_hash['bundle']

    chosen_listing = response.first
    @hood_name = chosen_listing['subdivision']
    @chosen_mls_num = chosen_listing['mlsListingID']
    @image_url = chosen_listing['media'].first['url']
    @price = chosen_listing['price']
    @address = chosen_listing['address']
    @dom = chosen_listing['daysOnMarket']
    @beds = chosen_listing['bedrooms']
    @baths = chosen_listing['baths']

    #agent info:
    # @agent_code = chosen_listing['mlsAgentID']
    #
    # agent_response = HTTParty.get("https://rets.io/api/v1/#{vendor}/agents?access_token=#{ENV['server_token']}&mlsAgentID=#{@agent_code}")
    # agent_response = agent_response.to_hash['bundle']
    #
    # chosen_agent = agent_response.first
    # @agent_name = chosen_agent['fullName']
    # @agent_cell = chosen_agent['cellPhone']

  end
end
