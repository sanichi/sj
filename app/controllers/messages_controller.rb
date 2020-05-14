class MessagesController < ApplicationController
  authorize_resource class: false

  def pull
    @player = Player.find_by(id: params[:player_id])

    if @player
      @game = @player.game

      last_message_id = params[:last_message_id].to_i

      @messages = @game.messages.where("id > ?", last_message_id)
      @last_message_id = last_message_id
      @messages.each do |m|
        @last_message_id = m.id if m.id > @last_message_id
      end
    else
      render "abort"
    end
  end

  def push
    game = Game.find_by(id: params[:game_id])
    if game
      if params[:player_id] && params[:card_index]
        game.reveal(params[:player_id].to_i, params[:card_index].to_i)
      elsif params[:game_id] && params[:pack_vis]
        game.pack_vis(params[:pack_vis] == "true")
      end
    end
  end
end
