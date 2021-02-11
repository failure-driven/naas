class SitesController < ApplicationController
  layout "site_application"
  before_action :authenticate_user
  before_action :set_site, only: %i[show edit update destroy]

  # TODO: check you can do anything as current_user

  def index
    @sites = current_user.sites
  end

  def show
    @key_count = @site.keys.length
  end

  def new
    @site = Site.new
  end

  # def edit
  # end

  def create
    @site_user = current_user.site_users.new(site: Site.new(site_params))

    if @site_user.save
      redirect_to @site_user.site, notice: "Site was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    # TODO: check you can update
    if @site.update(site_params)
      redirect_to @site, notice: "Site was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def notifications
    set_site
    @notifications = Notification.all # Notifications.where(read_access includes @site.id)
  end

  def metrics
    set_site
    @metrics = []
  end

  def access
    set_site
    @site_users = @site.users
  end

  def settings
    set_site
    @keys = @site.keys
  end

  def create_key
    set_site
    @key = Key.generate_key_for(@site)

    if @key.save
      redirect_to settings_site_path(@site), notice: "Key was successfully generated."
    else
      flash[:danger] = "could not create key #{@key.errors.messages}"
      redirect_to settings_site_path(@site)
    end
  end

  def destroy_key
    set_site
    # TODO: check ownership

    @key = Key.find(params[:key_id])
    @key.destroy

    redirect_to settings_site_path(@site), notice: "Key was successfully destroyed."
  end

  private

  def set_site
    @site = Site.find(params[:id])
  end

  def site_params
    params.require(:site).permit(:url)
  end
end
