class MobileController < ApplicationController

  def menu
    @categories = Category.issued
    render :json => @categories
  end

end

