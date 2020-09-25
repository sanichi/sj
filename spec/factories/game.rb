FactoryBot.define do
  factory :game do
    user
    participants { Game::PARTICIPANTS.sample }
    upto         { Game::UPTO.sample }
    peek         { [true, false].sample }
    debug        { [true, false].sample }
  end
end
