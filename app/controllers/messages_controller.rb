class MessagesController < ApplicationController
  authorize_resource class: false

  def updates
    player = Player.find(params[:player])
    game = player.game

    if game.messages.count == 0
      player.messages.create(pack: game.card, broadcast: true)
      player.messages.create(disc: game.card, broadcast: true)
    end

    if player.messages.where(broadcast: false).count == 0
      player.messages.create(hand: game.cards(12))
      game.messages.where.not(player: player).where(broadcast: true).each do |m|
        Message.create(player: player, json: m.json)
      end
    end

    restart = params[:number].to_i == 0

    old = restart ? player.messages.where.not(sent: 0).to_a : []
    new = player.messages.where(sent: 0).to_a

    @messages = old + new
    @messages.each { |m| m.update_column(:sent, m.sent + 1) }
  end
end
