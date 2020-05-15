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
      if player_id
        if card_index
          game.reveal(player_id, card_index)
        elsif pack_card_index
          game.pack_card(player_id, pack_card_index)
        elsif pack_discard_card_index
          game.pack_discard_card(player_id, pack_discard_card_index)
        end
      elsif elm_state
        game.elm_state(elm_state)
      end
    end
  end

  private

  [:card_index, :elm_state, :pack_card_index, :pack_discard_card_index, :player_id].each do |key|
    define_method(key) { params[key] && params[key].to_i }
  end
end
