json.last_message_id @last_message_id
json.updates(@messages.map { |m| JSON.parse(m.json) })
