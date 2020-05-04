json.player @player.id
json.players @player.game.players.pluck(:id)
json.messages @messages.map { |m| JSON.parse(m.json) }
