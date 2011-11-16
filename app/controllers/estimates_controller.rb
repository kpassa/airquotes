class EstimatesController < ApplicationController
  load_and_authorize_resource :estimate

  # GET /estimates
  # GET /estimates.json
  def index
  end

  # GET /estimates/1
  # GET /estimates/1.json
  def show
  end

  def get_product( country, program, coverage )
    product = Product.where( :country_id => country,
                              :program_id => @program,
                              :coverage_id => coverage ).first or
      raise "No product with (country, program, coverage) = (#{country.name}, #{@program}, #{coverage.description})"      
  end

  # GET /estimates/new
  # GET /estimates/new.json
  def new
    @country = current_user.country
    @program = Program.find_by_name!(params[:program])
    @coverage = Coverage.find_by_description!("Completa")
    @estimate.coverage = @coverage
    @product = get_product( @country, @program, @coverage )
    @estimate.product = @product
    @estimate.client = Client.new
    @estimate.letter = Letter.find_by_program_id!(@program)
  end

  # GET /estimates/1/edit
  def edit
    @country = @estimate.user.country
    @program = @estimate.program
    @coverage = @estimate.coverage
    @product = @estimate.product
    @client = @estimate.client
  end

  # POST /estimates
  # POST /estimates.json
  def create
    if @estimate.save
      country = current_user.country
      @program = params[:program]
      coverage = @estimate.coverage
      @estimate.product = Product.where( country_id: country, program_id: @program, coverage_id: coverage ).first or
        raise "No product with (country, program, coverage) = (#{country.name}, #{@program}, #{coverage.description})"
      redirect_to @estimate, notice: 'Estimate was successfully created.'
      @estimate.save
    else
      render action: "new"
    end
  end

  # PUT /estimates/1
  # PUT /estimates/1.json
  def update
    if @estimate.update_attributes(params[:estimate])
      redirect_to @estimate, notice: 'Estimate was successfully updated.'
    else
      render action: "edit"
    end
  end

  # DELETE /estimates/1
  # DELETE /estimates/1.json
  def destroy
    @estimate.destroy
    redirect_to estimates_url
  end

end
