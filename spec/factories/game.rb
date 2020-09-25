FactoryBot.define do
  factory :game do
    user
    participants { Game::PARTICIPANTS.sample }
    upto         { Game::UPTO.sample }
    four         { [true, false].sample }
    peek         { [true, false].sample }
    debug        { [true, false].sample }
  end
end
