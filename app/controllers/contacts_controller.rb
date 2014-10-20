class ContactsController < ApplicationController

  def new
    @contact = Contact.new
  end

  def create
    begin
      @contact = Contact.new(contact_params)
      @contact.request = request
      if @contact.deliver
        flash.now[:notice] = t('.thanks')
      else
        render :new
      end
    rescue ScriptError
      flash[:error] = t('.error')
    end
  end

  private
  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :email, :phone, :message)
  end
end
