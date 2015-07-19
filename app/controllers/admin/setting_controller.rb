class Admin::SettingController < Admin::BaseController
  load_and_authorize_resource

  before_action :fetch_setting, only: [:update, :destroy]

  def current_issue
    @setting = Setting.where(meta_key: "current_issue").first_or_create
    @issue = Issue.published_only.find_by(id: @setting.meta_value)
    @available_dates = AvailableDatesPresenter.new(date: @issue.try(:date))
  end

  def block_placements
    @settings = Setting.where(meta_key: "block_placement")
  end

  def create
    @setting = Setting.new(setting_params)
    if @setting.save
      redirect_to(:back, notice: "Setting was successfully updated.", setting: @setting)
    else
      redirect_to(:back, notice: "Something going wrong", setting: @setting)
    end
  end

  def update
    if @setting.update_attributes(setting_params)
      redirect_to(:back, notice: "Setting was successfully updated.", setting: @setting)
    else
      redirect_to(:back, notice: "Something going wrong", setting: @setting)
    end
  end

  def destroy
    @setting.destroy!
    redirect_to(:back, notice: "Setting was successfully deleted")
  end

  private

  def setting_params
    params.require(:setting).permit!
  end

  def fetch_setting
    @setting = Setting.find(params[:id])
  end
end
