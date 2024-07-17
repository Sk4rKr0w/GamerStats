

class SquadsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :save, :my_squads, :edit, :update, :compare, :destroy]
  before_action :clean_unsaved_squads, only: [:new, :my_squads]

  def new
    @squad = Squad.new
    5.times { @squad.players.build }
  end

  def create
    @squad = Squad.new(squad_params)
    @squad.user = current_user

    if @squad.valid?
      @squad.players.each(&:fetch_details)
      flash[:notice] = 'Squad was successfully created.'
      redirect_to @squad and return
    else
      render :new
    end
  end

  def show
    @squad = Squad.find(params[:id])
  end

  def save
    @squad = Squad.find(params[:id])
    if @squad.update(saved: true)
      flash[:notice] = 'Squad was successfully saved.'
      redirect_to @squad
    else
      flash[:alert] = 'Unable to save squad.'
      redirect_to @squad
    end
  end

  def index
    @squads = Squad.where(saved: true)
  end

  def my_squads
    @squads = current_user.squads.where(saved: true)
  end

  def edit
    @squad = current_user.squads.find(params[:id])
  end

  def update
    @squad = current_user.squads.find(params[:id])
    if @squad.update(squad_params)
      @squad.players.each(&:fetch_details)
      redirect_to @squad, notice: 'Squad was successfully updated.'
    else
      render :edit
    end
  end

  def compare
    @squads = Squad.where(saved: true)
    @squad1 = Squad.find(params[:squad1]) if params[:squad1].present?
    @squad2 = Squad.find(params[:squad2]) if params[:squad2].present?
  end

  def destroy
    @squad = current_user.squads.find(params[:id])
    if @squad.destroy
      flash[:notice] = 'Squad was successfully deleted.'
    else
      flash[:alert] = 'Unable to delete squad.'
    end
    redirect_to my_squads_path
  end

  private

  def squad_params
    params.require(:squad).permit(:name, :description, :creator_name, players_attributes: [:id, :riot_id, :game_tag, :_destroy])
  end

  def clean_unsaved_squads
    current_user.squads.where(saved: false).destroy_all
  end
end
