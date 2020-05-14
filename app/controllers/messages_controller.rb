class MessagesController < ApplicationController
  authorize_resource class: false

  def pull
    @player = Player.find_by(id: params[:player_id])

    if @player
      @updates = @player.game.messages.where("id > ?", params[:last_message_id].to_i).map do |m|
        update = JSON.parse(m.json)
        update[:mid] = m.id
        update
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
      elsif params[:pack_vis]
        game.pack_vis(params[:pack_vis] == "true")
      end
    end
  end
end
