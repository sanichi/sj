class Message < ApplicationRecord
  belongs_to :game
  before_save :generate_json

  attribute :key, :string
  attribute :val, :integer, array: true

  default_scope { order(:id) }

  private

  def generate_json
    self.json = JSON.generate({ key: key, val: val })
  end
end
