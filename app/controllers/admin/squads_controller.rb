class Admin::SquadsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @squads = Squad.all.includes(:players)
  end

  def show
    @squad = Squad.find(params[:id])
    @players = @squad.players
  end

  def destroy
    @squad = Squad.find(params[:id])
    @squad.destroy
    flash[:notice] = "Squad deleted successfully"
    redirect_to admin_squads_path
  end

  private

  def authenticate_admin!
    redirect_to root_path, alert: "Access denied" unless current_user.admin?
  end
end
