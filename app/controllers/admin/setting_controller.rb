class Admin::SettingController < Admin::BaseController
  load_and_authorize_resource

  def current_issue
    @setting = Setting.find_or_create_by_meta_key("current_issue")
    @issue = Issue.published_only.find_by(id: @setting.meta_value)
    @available_dates = AvailableDatesPresenter.new(date: @issue.try(:date))
  end

  def block_placements
    @settings = Setting.where(meta_key: "block_placement")
  end

  def create
    @setting = Setting.new(params[:setting])
    if @setting.save
      redirect_to(:back, notice: "Setting was successfully updated.", setting: @setting)
    else
      redirect_to(:back, notice: "Something going wrong", setting: @setting)
    end
  end

  def update
    @setting = Setting.find(params[:id])
    if @setting.update_attributes(params[:setting])
      redirect_to(:back, notice: "Setting was successfully updated.", setting: @setting)
    else
      redirect_to(:back, notice: "Something going wrong", setting: @setting)
    end
  end

  def destroy
    @setting = Setting.find(params[:id])
    @setting.destroy!
    redirect_to(:back, notice: "Setting was successfully deleted")
  end
end
