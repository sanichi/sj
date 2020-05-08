module GamesHelper
  def game_header(game)
    hdr = "Started by #{game.user.handle} "

    minutes = (Time.now.to_f - game.created_at.to_f).abs / 60.0
    days = minutes / 1440.0
    years = days / 365.0

    case
    when minutes <= 1 then hdr += "just now"
    when minutes <= 5 then hdr += "less than 5 minutes ago"
    when days    <= 1 then hdr += time_ago_in_words(game.created_at) + " ago"
    when days    <= 7 then hdr += game.created_at.strftime('last %a at %H:%m')
    when year    <= 1 then hdr += game.created_at.strftime('on %b %e at %H:%m')
    else                   hdr += game.created_at.strftime('on %Y-%m-%d')
    end
    hdr += ", "

    count = game.players.count
    diff = game.participants - count
    case
    when count == 0 then hdr += "waiting for #{game.participants} players to join"
    when diff > 0   then hdr += "waiting for #{diff} more player#{diff == 1 ? '' : 's'} to join"
    else                 hdr += "ready to start"
    end
    hdr += ". "

    hdr
  end

  def game_body(game)
    "Players: " + game.players.map { |p| p.user.handle }.join(", ")
  end
end
