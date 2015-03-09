class AvailableDatesPresenter < ApplicationPresenter
  attr_reader :date

  def initialize(options = {})
    @date = options.fetch(:date, nil)
  end

  def year
    @year ||= date && date.year.to_s
  end

  def month
    @month ||= date && date.month.to_s.rjust(2, '0')
  end

  def year_options
    helpers.options_for_select(years, year)
  end

  def month_options
    helpers.options_for_select(months, month)
  end

  def years
    @years ||= Issue.order(:date).pluck('year(date)').uniq.map(&:to_s)
  end

  def months
    @months ||= ('01'..'12')
  end
end
