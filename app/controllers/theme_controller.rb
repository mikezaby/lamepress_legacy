class ThemeController < ApplicationController

  layout $layout
  ActionController::Base.prepend_view_path("app/themes/#{$layout}")

end
