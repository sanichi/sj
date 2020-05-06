json.updates(@messages.map { |m| JSON.parse(m.json) })

json.debug(@debug) if @debug
