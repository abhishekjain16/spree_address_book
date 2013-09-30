class Spree::AddressesController < Spree::StoreController
  helper Spree::AddressesHelper
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  load_and_authorize_resource :class => Spree::Address

  def index
    @addresses = spree_current_user.addresses.includes(:state, :country)
  end

  def create
    @address = spree_current_user.addresses.build(params[:address])
    if @address.save
      flash[:notice] = Spree.t(:successfully_created, :resource => Spree.t(:address))
      redirect_to addresses_path
    else
      render :action => "new"
    end
  end
  
  def show
    redirect_to account_path
  end

  def edit
    session["user_return_to"] = request.env['HTTP_REFERER']
  end

  def new
    @address = Spree::Address.default
  end

  def update
    if @address.editable?
      if @address.update_attributes(params[:address])
        flash[:notice] = Spree.t(:successfully_updated, :resource => Spree.t(:address))
        redirect_back_or_default(addresses_path)
      else
        render :action => "edit"
      end
    else
      new_address = @address.clone
      new_address.attributes = params[:address]
      @address.update_attribute(:deleted_at, Time.now)
      if new_address.save
        flash[:notice] = Spree.t(:successfully_updated, :resource => Spree.t(:address))
        redirect_back_or_default(addresses_path)
      else
        render :action => "edit"
      end
    end
  end

  def destroy
    @address.destroy

    flash[:notice] = Spree.t(:successfully_removed, :resource => Spree.t(:address))
    redirect_to(request.env['HTTP_REFERER'] || account_path) unless request.xhr?
  end
end
