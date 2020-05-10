module GamesHelper
  def game_started(game)
    seconds = Time.now.to_f - game.created_at.to_f
    minutes = seconds / 60.0
    days = minutes / 1440.0
    years = days / 365.0

    case
    when seconds <= 9 then "just now"
    when minutes <= 1 then "less than a minuute ago"
    when minutes <= 2 then "less than 2 minutes ago"
    when minutes <= 5 then "less than 5 minutes ago"
    when days    <= 1 then time_ago_in_words(game.created_at) + " ago"
    when days    <= 7 then game.created_at.strftime('last %a at %H:%m')
    when year    <= 1 then game.created_at.strftime('on %b %e at %H:%m')
    else                   game.created_at.strftime('on %Y-%m-%d')
    end
  end

  def game_status(game)
    handles = game.players.map {|p| p.user.handle }
    count = handles.size
    needed = game.participants - count
    if count == 0
      t("game.status.none")
    elsif count == 1
      t("game.status.one", handle: handles.first, number: needed)
    else
      last = handles.pop
      list = "#{handles.join(', ')} and #{last}"
      if needed > 0
        t("game.status.some", some: count, handles: list, number: needed)
      else
        t("game.status.ready", handles: list)
      end
    end
  end

  def game_js_player_list(game, player_id)
    players = game.players.sort_by { |p| p.id }
    south = players.index{ |p| p.id == player_id }.to_i
    players.rotate!(south)
    positions = case players.count
    when 2 then ["S", "N"]
    when 3 then ["S", "NW", "NE"]
    else        ["S", "W", "N", "E"]
    end
    players.map do |player|
      "{ id: #{player.id}, handle: '#{player.user.handle}', position: '#{positions.shift}'}"
    end.join(", ").html_safe
  end

  def game_participants_menu(selected)
    options_for_select(Game::PARTICIPANTS.map { |n| [n.to_s, n] }, selected)
  end

  def game_upto_menu(selected)
    options_for_select(Game::UPTO.map { |n| [n.to_s, n] }, selected)
  end
end
