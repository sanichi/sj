class Message < ApplicationRecord
  belongs_to :game

  default_scope { order(:id) }
end
