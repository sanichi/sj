class PagesController < ApplicationController
  authorize_resource class: false

  def play
    @player = current_player
  end
end
