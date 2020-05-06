class Game < ApplicationRecord
  CARDS = (-2..12).to_a

  has_many :players, dependent: :destroy
  has_many :messages, through: :players

  default_scope { order(created_at: :desc) }

  def total_remaining
    CARDS.map { |c| send(card_to_attr(c)) }.sum
  end

  def total_dealt
    150 - total_remaining
  end

  def card
    count = total_remaining
    return 0 if count <= 0
    r = rand(count)
    running = 0
    CARDS.each do |c|
      a = card_to_attr(c)
      count = send(a)
      running += count
      if running > r
        update_column(a, count - 1)
        return c
      end
    end
    return 0
  end

  def cards(num)
    return [] if num <= 0
    num.times.map { card }
  end

  private

  def card_to_attr(c)
    "#{c < 0 ? 'm' : 'p'}#{c.abs}"
  end
end
