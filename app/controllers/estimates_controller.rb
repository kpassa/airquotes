class EstimatesController < ApplicationController
  load_and_authorize_resource :estimate

  # GET /estimates
  # GET /estimates.json
  def index
  end

  # GET /estimates/1
  # GET /estimates/1.json
  def show
    @client = @estimate.client
    @product = @estimate.product
    @program = @product.program
    @coverage = @product.coverage
    @letter = @program.letter
    @fee_calc = @product.fee_calc
    @letter_vars = {
      fecha:             @estimate.created_at.to_s,
      cliente:           @client.full_name,
      cliente_nombres:   @client.names,
      cliente_titulo:    @client.title,
      cliente_telefono1: @client.phone1,
      cliente_telefono2: @client.phone2,
      cliente_email:     @client.email,
      vendedor:          current_user.name,
      vendedor_titulo:   current_user.title,
      vendedor_telefono: current_user.phone
    }
    @table_vars = {
      edad_titular:        @client.age,
      edad_conyugue:       @client.spouse_age || 0,
      genero_titular:      @client.gender,
      genero_conyugue:     [ "masculino", "femenino" ].reject{ |g| g == @client.gender }.first,
      monto_titular:       @estimate.policyholder_amount,
      monto_conyugue:      @estimate.spouse_amount,
      dental:              @estimate.dental ? 1 : 0,
      enfermedades_graves: @estimate.severe_illness ? 1 : 0,
      beneficiarios:       @estimate.beneficiaries
    }
    @attachments = @product.attachments
    render "show", :layout => "without_sidebar"
  end

  def get_product( country, program, coverage )
    Product.where( :country_id => country,
                   :program_id => program,
                   :coverage_id => coverage ).first or
      raise "No product with (country, program, coverage) = (#{country.name}, #{@program}, #{coverage.description})"      
  end

  # GET /estimates/new
  # GET /estimates/new.json
  def new
    @country = current_user.country
    @program = Program.find(params[:program_id])
    @coverage = Coverage.find(params[:coverage_id])
    @product = get_product( @country, @program, @coverage )

    @estimate.program = @program
    @estimate.coverage = @coverage
    @estimate.product = @product
    @estimate.client = Client.new
    @estimate.letter = Letter.find_by_program_id!(@program)
    render :new, :layout => "without_sidebar"
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
      redirect_to @estimate, notice: 'Estimate was successfully created.'
    else
      @program = @estimate.program
      @coverage = @estimate.coverage
      @product = @estimate.product
      render :new, :layout => "without_sidebar"
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
