namespace :games do
  # Meant for an occasional cron. For example:
  # 10 3 1,14,28 * * cd /var/www/me.sj/current; RAILS_ENV=production bin/rails games:compact >> log/cron.log 2>&1
  desc "delete the messages of finished games older than a certain age to save DB space"
  task :compact, [:print] => :environment do |task, args|
    cut1 = 62.days.ago
    cut2 = 31.days.ago
    ids = Game.where(state: Game::FINISHED).where("updated_at < ?", cut2).where("updated_at > ?", cut1).pluck(:id)
    ids.reject!{|id| id % 100 == 0} # preserve a few for posterity
    before = Message.count
    Message.where(game_id: ids).delete_all unless ids.empty?
    after = Message.count
    if args[:print] == 'p'
      puts "games considered: #{ids.length}"
      puts "messages deleted: #{before - after}"
    end
  end
end
