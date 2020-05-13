class Message < ApplicationRecord
  belongs_to :game
  before_save :generate_json

  attribute :pack, :integer
  attribute :pack_vis, :boolean
  attribute :discard, :integer
  attribute :player_id, :integer
  attribute :hand, :integer, array: true
  attribute :reveal, :integer

  default_scope { order(:id) }

  private

  def generate_json
    data = {}
    [:pack, :pack_vis, :discard, :player_id, :hand, :reveal].each do |atr|
      data[atr] = send(atr) unless send(atr).nil?
    end
    self.json = JSON.generate(data)
  end
end
