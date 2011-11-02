class EstimatesController < ApplicationController
  load_and_authorize_resource :estimate, :except => [ :new, :create ]

  # GET /estimates
  # GET /estimates.json
  def index
  end

  # GET /estimates/1
  # GET /estimates/1.json
  def show
  end

  # Smells.  Better to turn the program string into the class
  # name directly.
  def estimate_class(program)
    logger.info "descendants: #{Estimate.descendants.to_s}"
    if program == "PSM"
      PsmEstimate
    elsif program == "ST"
      StEstimate
    else
      nil
    end
  end
      
  # GET /estimates/new
  # GET /estimates/new.json
  def new
    @program = Program.find_by_name!(params[:program])
    eclass = estimate_class(params[:program])
    unless eclass
      redirect_to root_url, notice: "Need valid program" and return
    end
    @estimate = eclass.new
    @estimate.user = current_user
    authorize! :create, @estimate
    country = current_user.country
    coverage = Coverage.find_by_description!("Completa")
    @estimate.coverage = coverage
    @estimate.product = Product.where( :country_id => country,
                                       :program_id => @program,
                                       :coverage_id => coverage ).first or
        raise "No product with (country, program, coverage) = (#{country.name}, #{@program}, #{coverage.description})"      
    
    @estimate.client = Client.new
    @estimate.letter = Letter.find_by_program_id!(@program)
  end

  # GET /estimates/1/edit
  def edit
  end

  # POST /estimates
  # POST /estimates.json
  def create
    @program = Program.find_by_name!(params[:program])
    eclass = estimate_class(params[:program])
    unless eclass
      redirect_to root_url, notice: "Need valid program" and return
    end
    @estimate = eclass.new( params[:estimate] )
    @estimate.user = current_user
    authorize! :create, @estimate
    if @estimate.save
      country = current_user.country
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
