class JavascriptsController < ApplicationController
  def dynamic_dates
    @issues = Issue.find(:all, :order => "number DESC")
  end

  def dynamic_dates_pub
    @issues = Issue.where(published: true).order("number DESC")
    render "dynamic_dates"
  end

  def date_picker

  end

  def admin_date_picker

  end

end

