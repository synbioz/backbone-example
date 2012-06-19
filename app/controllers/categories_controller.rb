class CategoriesController < ApplicationController
  respond_to :json

  def index
    @categories = Category.all
    respond_with(@categories)
  end

  def show
  end

  def create
    @category = Category.new params[:category]
    if @category.save
      respond_with(@category)
    else
      render :status => 500, :json => @category.errors.full_messages.join(', ')
    end
  end

end