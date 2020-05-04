class MessagesController < ApplicationController
  authorize_resource class: false

  def ping
    @player = current_player
    @messages = @player.messages.where(sent: false)
    @messages.each { |m| m.update_column(:sent, true) }
  end
end
