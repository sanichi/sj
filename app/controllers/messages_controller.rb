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
    if params[:player_id] && params[:card_index]
      # reveal a card belonging to a player in a game
      player = Player.find_by(id: params[:player_id])
      player.game.messages.create(key: "reveal", val: [player.id, params[:card_index].to_i]) if player
    elsif params[:game_id] && params[:pack_vis]
      # make the card on top of the pack visisble/invisible
      bool = params[:pack_vis] == "true"
      game = Game.find_by(id: params[:game_id])
      game.messages.create(key: "pack_vis", val: [1]) if game
    end
  end
end
