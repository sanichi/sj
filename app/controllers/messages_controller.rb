class MessagesController < ApplicationController
  authorize_resource class: false

  def ping
    @game = Game.current_game
  end
end
