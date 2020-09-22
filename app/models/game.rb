class Game < ApplicationRecord
  include Pageable

  CARDS = (-2..12).to_a
  PARTICIPANTS = [2, 3, 4]
  UPTO = [25, 50, 100, 200, 300, 400, 500]
  VARIANTS = %w/standard peek/

  WAITING = "waiting"
  STARTED = "started"
  FINISHED = "finished"

  has_many :players, dependent: :destroy
  has_many :messages, dependent: :destroy
  belongs_to :user

  validates :participants, numericality: { integer_only: true}, inclusion: { in: PARTICIPANTS }
  validates :upto, numericality: { integer_only: true, greater_than_or_equal_to: UPTO.first, less_than_or_equal_to: UPTO.last }
  validates :variant, inclusion: { in: VARIANTS }

  default_scope { order(created_at: :desc) }

  def self.search(params, path, opt={})
    if user = User.find_by(id: params[:user_id])
      matches = user.games
    else
      matches = all
    end
    matches = matches.includes(:user).includes(:players)
    paginate(matches, params, path, opt)
  end

  def get_messages(target, last_message_id)
    return messages if last_message_id == 0

    messages
      .where(only_start: false)
      .where("id > ?", last_message_id)
      .where("target = ? OR target = ? OR (target < 0 AND target != ?)", Message::ALL, target, -target)
  end

  def start
    add_msg("deal_pack", card)
    add_msg("deal_discard", card)
  end

  def deal(pid)
    add_msg("deal_hand", cards(12).unshift(pid))
  end

  def reveal(pid, cid)
    add_msg("reveal_card", [pid, cid], not: pid)
  end

  def discard_card(pid, cid)
    add_msg("discard_card", [pid, cid], not: pid)
  end

  def discard_chosen(pid)
    add_msg("discard_chosen", pid, only_start: true)
  end

  def pack_chosen(pid)
    add_msg("pack_chosen", pid, not: pid)
  end

  def pack_card(pid, cid)
    add_msg("pack_card", [pid, cid], not: pid)
    add_msg("deal_pack", card)
  end

  def pack_discard_card(pid, cid)
    add_msg("pack_discard_card", [pid, cid], not: pid)
    add_msg("deal_pack", card)
  end

  def pack_discard_chosen(pid)
    add_msg("pack_discard_chosen", pid, only_start: true)
  end

  def next_hand(player, score)
    # https://www.peterdebelak.com/blog/pessimistic-locking-in-rails-by-example/
    with_lock do
      add_msg("next_hand", [player.id, score], only_start: true)
      player.update_column(:score, score)
      if votes + 1 == participants
        update_column(:votes, 0)
        update_column(:hand, hand + 1)
        players.each do |p|
          add_msg("reset_player", [p.id, p.score])
        end
        new_pack if shuffle?
        add_msg("deal_pack", card)
        add_msg("deal_discard", card)
        players.each do |p|
          add_msg("deal_hand", cards(12).unshift(p.id))
        end
      else
        update_column(:votes, votes + 1)
      end
    end
  end

  def end_game(player, pid_scores)
    with_lock do
      unless state == FINISHED
        update_column(:state, FINISHED)
        touch
        pid_scores.each_slice(2) do |pid, score|
          player = Player.find_by(id: pid)
          player.update_column(:score, score) if player && score
        end
        finalise_scores
      end
      add_msg("end_game", player.id, only_start: true)
    end
  end

  def can_be_joined_by?(user)
    return false unless state == WAITING
    return false if players.count >= participants
    return false if players.pluck(:user_id).include?(user.id)
    true
  end

  def can_be_played_by(user)
    return unless players.count == participants
    players.find_by(user: user)
  end

  def can_be_deleted_by?(user)
    user == self.user && state != FINISHED
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

  def add_msg(k, v, **opts)
    if k == "test"
      json = v.to_s
    else
      v = [ 1 ] if v.class == TrueClass
      v = [ 0 ] if v.class == FalseClass
      v = [ v ] if v.class == Integer
      json = JSON.generate({ key: k, val: v })
    end

    msg = {json: json}
    msg[:target] = 0 + opts[:for] if opts[:for]
    msg[:target] = 0 - opts[:not] if opts[:not]
    msg[:only_start] = true if opts[:only_start]

    messages.create(msg)
  end

  def finished?
    state == FINISHED
  end

  def forget(from)
    messages.where("id >= ?", from).each { |m| m.destroy }
    update_column(:state, STARTED)
  end

  private

  def new_pack
    self.m2 =  5
    self.m1 = 10
    self.p0 = 15
    self.p1 = 10
    self.p2 = 10
    self.p3 = 10
    self.p4 = 10
    self.p5 = 10
    self.p6 = 10
    self.p7 = 10
    self.p8 = 10
    self.p9 = 10
    self.p10 = 10
    self.p11 = 10
    self.p12 = 10
    save
  end

  def card_to_attr(c)
    "#{c < 0 ? 'm' : 'p'}#{c.abs}"
  end

  def finalise_scores
    scores = players.pluck(:score)
    counts = scores.reduce(Hash.new(0)) { |h,s| h[s] = h[s] += 1; h }
    places = scores.uniq.sort.each_with_index.reduce(Hash.new(0)) { |h,(s,p)| h[s] = p + 1; h }
    players.each do |player|
      player.update_column(:pscore, (player.score * 100.0 / upto).round)
      player.update_column(:place, places[player.score] * (counts[player.score] == 1 ? 1 : -1))
      player.touch
    end
  end
end
