class SquadsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :save, :my_squads, :edit, :update]

  def new
    @squad = Squad.new
    5.times { @squad.players.build }
  end

  def create
    @squad = Squad.new(squad_params)
    @squad.user = current_user

    if @squad.save
      @squad.players.each(&:fetch_details)
      redirect_to @squad, notice: 'Squad was successfully created.' and return
    else
      render :new
    end
  end

  def show
    @squad = Squad.find(params[:id])
  end

  def save
    @squad = Squad.find(params[:id])
    @squad.update(saved: true)

    redirect_to @squad, notice: 'Squad was successfully saved.'
  end

  def index
    @squads = Squad.where(saved: true)
  end

  def my_squads
    @squads = current_user.squads
  end

  def edit
    @squad = current_user.squads.find(params[:id])
  end

  def update
    @squad = current_user.squads.find(params[:id])
    if @squad.update(squad_params)
      @squad.players.each(&:fetch_details)
      redirect_to new_squads_path, notice: 'Squad was successfully updated.'
    else
      render :edit
    end
  end


  private

  def squad_params
    params.require(:squad).permit(:name, :description, :creator_name, players_attributes: [:id, :riot_id, :game_tag, :_destroy])
  end
end
