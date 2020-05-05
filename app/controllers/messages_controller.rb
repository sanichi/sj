class MessagesController < ApplicationController
  authorize_resource class: false

  def updates
    @last_message = params[:last_message]
    @player = Player.find(params[:player])
    restart = params[:number].to_i == 0
    @old = restart ? @player.messages.where(sent: true) : []
    @new = @player.messages.where(sent: false)
    @messages = @old + @new
    @new.each { |m| m.update_column(:sent, true) }
  end
end
