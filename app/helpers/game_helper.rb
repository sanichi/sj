module GameHelper
  def game_header(game)
    out = "Started "

    player = game.players.first
    out += "by #{player.user.handle} " if player

    minutes = (Time.now.to_f - game.created_at.to_f).abs / 60.0
    days = minutes / 1440.0
    years = days / 365.0

    case
    when minutes <= 1 then out += "just now"
    when minutes <= 5 then out += "less than 5 minutes ago"
    when days    <= 1 then out += time_ago_in_words(game.created_at) + " ago"
    when days    <= 7 then out += game.created_at.strftime('last %a at %H:%m')
    when year    <= 1 then out += game.created_at.strftime('on %b %e at %H:%m')
    else                   out += game.created_at.strftime('on %Y-%m-%d')
    end

    out
  end
end
