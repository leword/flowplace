class CurrenciesController < ApplicationController
  require_authorization(:admin) 
  # GET /currencies
  # GET /currencies.xml
  def index
    @currencies = Currency.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @currencies }
    end
  end

  # GET /currencies/1
  # GET /currencies/1.xml
  def show
    @currency = Currency.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @currency }
    end
  end

  # GET /currencies/new
  # GET /currencies/new.xml
  def new
    @currency = Currency.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @currency }
    end
  end

  # GET /currencies/1/edit
  def edit
    @currency = Currency.find(params[:id])
  end

  # POST /currencies
  # POST /currencies.xml
  def create
    params_key = params[:currency_params_key]
    @currency = Currency.new(params[params_key])
    @currency.type = params[params_key][:type]
    respond_to do |format|
      if @currency.save
        flash[:notice] = 'Currency was successfully created.'
        format.html { redirect_to currencies_url }
        format.xml  { render :xml => @currency, :status => :created, :location => @currency }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @currency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /currencies/1
  # PUT /currencies/1.xml
  def update
    @currency = Currency.find(params[:id])
    params_key = params[:currency_params_key]

    respond_to do |format|
      if @currency.update_attributes(params[params_key])
        flash[:notice] = 'Currency was successfully updated.'
        format.html { redirect_to currencies_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @currency.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /currencies/1
  # DELETE /currencies/1.xml
  def destroy
    @currency = Currency.find(params[:id])
    @currency.destroy

    respond_to do |format|
      format.html { redirect_to(currencies_url) }
      format.xml  { head :ok }
    end
  end
end
