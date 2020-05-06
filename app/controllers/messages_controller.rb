class MessagesController < ApplicationController
  authorize_resource class: false

  def updates
    player = Player.find(params[:player])

    if player.messages.count == 0
      cards = player.game.cards(14)
      player.messages.create(pack: cards.pop, broadcast: true)
      player.messages.create(disc: cards.pop, broadcast: true)
      player.messages.create(hand: cards)
    end

    restart = params[:number].to_i == 0

    old = restart ? player.messages.where(sent: true) : []
    new = player.messages.where(sent: false)
    new.each { |m| m.update_column(:sent, true) }

    @messages = old + new
  end
end
