json.player @player.id
json.players @player.game.players.pluck(:id)
