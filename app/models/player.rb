class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game
  has_many :messages, dependent: :destroy
end
