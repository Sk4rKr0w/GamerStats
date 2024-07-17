# app/mailers/ticket_mailer.rb
class TicketMailer < ApplicationMailer
    default from: 'admin@yourapp.com'
    
    def send_message(ticket, message)
      @ticket = ticket
      @message = message
      mail(to: @ticket.user.email, subject: "Message Regarding Your Ticket")
    end
  end
  