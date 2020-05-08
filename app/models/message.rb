class Message < ApplicationRecord
  belongs_to :game
  before_save :generate_json

  attribute :disc, :integer
  attribute :pack, :integer
  attribute :hand, :integer, array: true
  attribute :player, :integer

  private

  def generate_json
    data = {}
    data[:hand] = hand if hand
    data[:disc] = disc if disc
    data[:pack] = pack if pack
    data[:player] = player if player
    self.json = JSON.generate(data)
  end
end
