class ContactMailer < ApplicationMailer
  default from: 'no-reply@example.com'  # Sostituisci con il tuo indirizzo email di default

  def contact_email(contact)
    @contact = contact
    mail(to: 'support@example.com', subject: 'New Contact Us Message')  # Sostituisci con l'indirizzo email e il soggetto desiderati
  end
end
