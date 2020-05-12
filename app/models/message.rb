class Message < ApplicationRecord
  belongs_to :game
  before_save :generate_json

  attribute :pack, :integer
  attribute :discard, :integer
  attribute :player_id, :integer
  attribute :hand, :integer, array: true
  attribute :reveal, :integer

  private

  def generate_json
    data = {}
    [:pack, :discard, :player_id, :hand, :reveal].each do |atr|
      data[atr] = send(atr) if send(atr)
    end
    self.json = JSON.generate(data)
  end
end
