namespace :games do
  # Meant for an occasional cron. For example:
  # 10 3 1,14,28 * * cd /var/www/me.sj/current; RAILS_ENV=production bin/rails game:compact >> log/cron.log 2>&1
  desc "delete the messages of finished games older than a certain age to save DB space"
  task :compact, [:print] => :environment do |task, args|
    cutoff = 31.days.ago
    ids = Game.where(state: Game::FINISHED).where("updated_at < ?", cutoff).pluck(:id)
    before = Message.count
    Message.where(game_id: ids).delete_all
    after = Message.count
    puts "messages deleted: #{before - after}" if args[:print] == 'p'
  end
end
