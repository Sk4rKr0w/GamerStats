class Admin::TicketsController < ApplicationController
  before_action :set_ticket, only: [:show, :edit, :update, :destroy, :resolve, :send_message]

  def index
    @tickets = Ticket.all
      Rails.logger.debug "Tickets loaded: #{@tickets.inspect}"
  end

  def show
  end

  def edit
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to admin_ticket_path(@ticket), notice: 'Ticket was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @ticket.destroy
    redirect_to admin_tickets_path, notice: 'Ticket was successfully destroyed.'
  end

  def resolve
    @ticket.update(status: 'resolved')
    redirect_to admin_tickets_path, notice: 'Ticket was successfully resolved.'
  end

  def send_message
    message = params[:message]
    TicketMailer.send_message(@ticket, message).deliver_now
    redirect_to admin_ticket_path(@ticket), notice: 'Message was successfully sent.'
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:subject, :message, :status, :user_id)
  end
end
