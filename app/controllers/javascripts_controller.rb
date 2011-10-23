class JavascriptsController < ApplicationController

	def dynamic_categories
		@categories = Category.find(:all)
	end

	def dynamic_dates
		@issues = Issue.find(:all, :order => "number DESC")
	end

	def misc

	end

	def sortable_list

	end

	def date_picker

	end

end

