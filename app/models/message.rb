class Message < ApplicationRecord
  belongs_to :game
  before_save :generate_json

  attribute :pack, :integer
  attribute :discard, :integer
  attribute :hand, :integer, array: true
  attribute :player_id, :integer

  private

  def generate_json
    data = {}
    data[:pack] = pack if pack
    data[:discard] = discard if discard
    data[:hand] = hand if hand
    data[:player_id] = player_id if player_id
    self.json = JSON.generate(data)
  end
end
