class ApplicationPresenter
  def helpers
    @helpers ||= ActionController::Base.helpers
  end
end
