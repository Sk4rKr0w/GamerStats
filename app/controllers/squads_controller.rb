class SquadsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :show, :save]

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

  private

  def squad_params
    params.require(:squad).permit(:name, players_attributes: [:riot_id, :game_tag])
  end
end
