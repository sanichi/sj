class Message < ApplicationRecord
  belongs_to :player
  before_save :convert_to_json

  def card(player, value, visible)
    cards = get_cards
    cards["players"] ||= []
    cards["players"].push [player, value, visible]
  end

  def disc(value)
    cards = get_cards
    cards["disc"] = value
  end

  def pack(top, bottom)
    cards = get_cards
    cards["pack"] = [top, bottom]
  end

  private

  def get_cards
    @cards ||= Hash.new
  end

  def convert_to_json
    self.json = JSON.generate(get_cards)
  end
end
