class MessagesController < ApplicationController
  authorize_resource class: false
  before_action :get_player

  def pull
    if @player
      last_message_id = params[:last_message_id].to_i

      @messages = @game.messages.where("id > ?", last_message_id)
      @last_message_id = last_message_id
      @messages.each do |m|
        @last_message_id = m.id if m.id > @last_message_id
      end
    end
  end

  def push
    if @player
      if params[:card_index]
        @game.messages.create(player_id: @player.id, reveal: params[:card_index].to_i)
      end
    end
  end

  private

  def get_player
    @player = Player.find_by(id: params[:player_id])
    @game = @player.game if @player
    render "abort" unless @player
  end
end
