class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.contact_email(@contact).deliver_now
      ticket = if current_user
                 Ticket.create(subject: @contact.subject, message: @contact.message, status: 'open', user_id: current_user.id)
               else
                 Ticket.create(subject: @contact.subject, message: @contact.message, status: 'open')
               end

      if ticket.persisted?
        flash[:notice] = "Your message has been sent and a ticket has been created."
        redirect_to new_contact_path
      else
        flash[:alert] = "Failed to create ticket."
        render :new
      end
    else
      render :new
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
