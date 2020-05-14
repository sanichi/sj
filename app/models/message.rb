class Message < ApplicationRecord
  belongs_to :game
  before_save :generate_json

  attribute :key, :string
  attribute :int, :integer
  attribute :bool, :boolean
  attribute :ints, :integer, array: true

  default_scope { order(:id) }

  private

  def generate_json
    val = case
    when ints then ints
    when int  then [ int ]
    else [ bool ? 1 : 0 ]
    end
    self.json = JSON.generate({ key: key, val: val })
  end
end
