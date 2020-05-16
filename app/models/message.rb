class Message < ApplicationRecord
  ALL = 0

  belongs_to :game

  default_scope { order(:id) }
end
