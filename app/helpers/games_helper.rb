module GamesHelper
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

  def game_started_by_menu(selected)
    opts = User.pluck(:handle, :id)
    opts.unshift [t("any"), ""]
    options_for_select(opts, selected)
  end

  def place(place)
    case place.abs
    when 1 then "1st"
    when 2 then "2nd"
    when 3 then "3rd"
    else "#{place.abs}th"
    end + (place < 0 ? "=" : "")
  end
end
