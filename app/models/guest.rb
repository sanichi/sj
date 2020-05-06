class Guest
  def admin?
    false
  end

  def guest?
    true
  end

  def can_play?(game)
    false
  end

  def can_join?(game)
    false
  end
end
