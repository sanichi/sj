class Player < ApplicationRecord
  belongs_to :user
  belongs_to :game

  scope :finished, -> { order(updated_at: :desc).includes(:game).where(games: { state: Game::FINISHED }) }
end
