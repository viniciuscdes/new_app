# ProductsController
class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  respond_to :json, :html
  before_filter :authenticate_user!,except: %i(show index)

  # GET /products
  # GET /products.json
  def index
    if params[:q]
      search_term = params[:q]
    if Rails.env.development?
      @products = Product.where("name LIKE ?", "%#{search_term}%")
    else
      @products = Product.where("name ILIKE ?", "%#{search_term}%")
    end
    else
      @products = Product.all

    end
    respond_with @products
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @products = Product.friendly.find(params[:id])
    @comments = @product.comments.order("created_at DESC").paginate(:page => params[:page], :per_page => 3)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    @product = Product.friendly.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: 'Product was successfully created.'}
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    redirect_to products_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:name, :description, :image_url, :colour, :price, :category)
    end
end
