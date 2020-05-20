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
      if card_index?
        game.reveal(pid, card_index)
      elsif discard_chosen?
        game.discard_chosen(pid)
      elsif discard_card_index?
        game.discard_card(pid, discard_card_index)
      elsif pack_chosen?
        game.pack_chosen(pid)
      elsif pack_card_index?
        game.pack_card(pid, pack_card_index)
      elsif pack_discard_chosen?
        game.pack_discard_chosen(pid)
      elsif pack_discard_card_index?
        game.pack_discard_card(pid, pack_discard_card_index)
      elsif next_hand?
        game.next_hand(@player, next_hand)
      elsif end_game?
        game.end_game(@player, end_game)
      end
    end
  end

  private

  def find_player
    @player = Player.find_by(id: params[:player_id])
  end

  PARAMS =
    [:last_message_id, :card_index, :next_hand,
     :discard_chosen, :discard_card_index,
     :pack_chosen, :pack_card_index,
     :pack_discard_chosen, :pack_discard_card_index,
    ]

  PARAMS.each { |k| define_method("#{k}?") { params[k] } }
  PARAMS.each { |k| define_method(k) { params[k].to_i } }

  def end_game?
    params[:end_game].is_a?(Array)
  end

  def end_game
    params[:end_game].map(&:to_i)
  end
end
