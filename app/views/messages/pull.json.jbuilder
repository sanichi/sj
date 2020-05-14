json.updates(@messages.map { |m| h = JSON.parse(m.json); h[:mid] = m.id; h })
