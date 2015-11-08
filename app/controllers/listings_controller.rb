class ListingsController < ApplicationController
  before_action :set_listing, only: [:show, :edit, :update, :destroy]

  # GET /listings
  def index
    @listings = Listing.all
    respond_to do |format|
      format.html
      format.csv { send_data @listings.to_csv }
      #format.xls # { send_data @products.to_csv(col_sep: "\t") }
    end
  end

  # GET /listings/1
  def show
    @listing = Listing.find(params[:id])
    get_details(@listing.mls_num, "armls")
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

  # GET /listings/new
  def new
    @listing = Listing.new
  end

  # GET /listings/1/edit
  def edit
  end

  # POST /listings
  def create
    @listing = Listing.new(listing_params)

    if @listing.save
      redirect_to @listing, notice: 'Listing was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /listings/1
  def update
    if @listing.update(listing_params)
      redirect_to @listing, notice: 'Listing was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /listings/1
  def destroy
    @listing.destroy
    redirect_to listings_url, notice: 'Listing was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listing
      @listing = Listing.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def listing_params
      params[:listing]
    end
end
