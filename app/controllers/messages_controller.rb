class MessagesController < ApplicationController
  authorize_resource class: false

  def pull
    player = Player.find(params[:player_id])
    game = player.game
    last_message_id = params[:last_message_id].to_i

    @messages = game.messages.where("id > ?", last_message_id)
    @last_message_id = last_message_id
    @messages.each do |m|
      @last_message_id = m.id if m.id > @last_message_id
    end
  end

  def push
    player = Player.find(params[:player_id])
    game = player.game
    if params[:card_index]
      game.messages.create(player_id: player.id, reveal: params[:card_index].to_i)
    end
  end
end
