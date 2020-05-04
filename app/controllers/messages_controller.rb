class MessagesController < ApplicationController
  authorize_resource class: false

  def ping
    @player = current_player
  end
end
