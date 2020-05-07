class Message < ApplicationRecord
  belongs_to :player
  before_save :generate_json

  attribute :disc, :integer
  attribute :pack, :integer
  attribute :hand, :integer, array: true

  private

  def generate_json
    unless json?
      data = {}
      data[:hand] = hand if hand
      data[:disc] = disc if disc
      data[:pack] = pack if pack
      self.json = JSON.generate(data)
    end
  end
end
