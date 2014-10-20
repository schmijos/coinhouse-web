class Contact < MailForm::Base
  append :remote_ip
  attribute :first_name, validate: true
  attribute :last_name, validate: true
  attribute :email, validate: /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :phone
  attribute :message, validate: true

  def headers
    {
        to: ENV['INFO_EMAIL'],
        from: %("#{first_name} #{last_name}" <#{email}>)
    }
  end
end