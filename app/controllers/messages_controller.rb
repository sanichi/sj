class MessagesController < ApplicationController
  authorize_resource class: false
  before_action :find_player

  def pull
    if @player && last_message_id
      @updates = @player.game.get_messages(@player.id, last_message_id).map do |m|
        update = JSON.parse(m.json)
        update[:mid] = m.id
        update
      end
    else
      render "abort"
    end
  end

  def push
    if @player
      pid = @player.id
      game = @player.game
      if card_index
        game.reveal(pid, card_index)
      elsif discard_card_index
        game.discard_card(pid, discard_card_index)
      elsif pack_chosen
        game.pack_chosen(pid)
      elsif pack_discard_chosen
        game.pack_discard_chosen(pid)
      elsif pack_card_index
        game.pack_card(pid, pack_card_index)
      elsif pack_discard_card_index
        game.pack_discard_card(pid, pack_discard_card_index)
      elsif elm_state
        game.elm_state(pid, elm_state)
      end
    end
  end

  private

  def find_player
    @player = Player.find_by(id: params[:player_id])
  end

  [:card_index, :elm_state, :pack, :discard_card_index, :last_message_id, :pack_card_index, :pack_chosen, :pack_discard_card_index, :pack_discard_chosen].each do |key|
    define_method(key) { params[key] && params[key].to_i }
  end
end
