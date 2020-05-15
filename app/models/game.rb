class Game < ApplicationRecord
  CARDS = (-2..12).to_a
  PARTICIPANTS = [2, 3, 4]
  UPTO = [50, 100, 200, 300, 400, 500]

  WAITING = "waiting"
  STARTED = "started"
  FINISHED = "finished"

  has_many :players, dependent: :destroy
  has_many :messages, dependent: :destroy
  belongs_to :user

  validates :participants, numericality: { integer_only: true}, inclusion: { in: PARTICIPANTS }
  validates :upto, numericality: { integer_only: true, greater_than_or_equal_to: UPTO.first, less_than_or_equal_to: UPTO.last }

  default_scope { order(created_at: :desc) }

  def start
    add_msg("pack", card)
    add_msg("discard", card)
  end

  def deal(pid)
    add_msg("hand", cards(12).unshift(pid))
  end

  def reveal(pid, cid)
    player = players.find_by(id: pid)
    add_msg("reveal", [player.id, cid]) if player
  end

  def elm_state(state)
    add_msg("elm_state", state)
  end

  def discard_card(pid, cid)
    add_msg("discard_card", [pid, cid])
  end


  def pack_card(pid, cid)
    add_msg("pack_card", [pid, cid, card])
  end

  def pack_discard_card(pid, cid)
    add_msg("pack_discard_card", [pid, cid, card])
  end

  def can_be_joined_by?(user)
    return false unless state == WAITING
    return false if players.count >= participants
    return false if players.pluck(:user_id).include?(user.id)
    true
  end

  def can_be_played_by?(user)
    return false unless state != FINISHED
    return false unless players.count == participants
    return false unless players.pluck(:user_id).include?(user.id)
    true
  end

  def can_be_left_by?(user)
    return false unless state == WAITING
    return false unless players.pluck(:user_id).include?(user.id)
    true
  end

  def can_be_deleted_by?(user)
    return true if user.admin?
    return true if user == self.user && state == WAITING
    false
  end

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

  def add_msg(k, v)
    v = [ 1 ] if v.class == TrueClass
    v = [ 0 ] if v.class == FalseClass
    v = [ v ] if v.class == Integer
    messages.create(json: JSON.generate({ key: k, val: v }))
  end

  def card_to_attr(c)
    "#{c < 0 ? 'm' : 'p'}#{c.abs}"
  end
end
