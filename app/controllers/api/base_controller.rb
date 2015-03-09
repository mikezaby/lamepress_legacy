class Api::BaseController < ApplicationController
  def api_response(resource, options = {}, &block)
    status = options.fetch(:status, 200)
    error_status = options.fetch(:error_status, 422)

    block.call if block_given?

    if status == 204
      render nothing: true, status: status
    else
      render json: resource, status: status
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotDestroyed
    render json: { errors: resource.errors }, status: error_status
  end
end
