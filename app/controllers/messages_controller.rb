class MessagesController < ApplicationController
  authorize_resource class: false

  def ping
    @greeting = "Hello"
  end
end
