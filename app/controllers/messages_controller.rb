class MessagesController < ApplicationController
  authorize_resource class: false

  def updates
    player = Player.find(params[:player_id])
    game = player.game
    last_message_id = params[:last_message].to_i

    @messages = game.messages.where("id > ?", last_message_id)
    @last_message_id = last_message_id
    @messages.each do |m|
      @last_message_id = m.id if m.id > @last_message_id
    end
  end
end
