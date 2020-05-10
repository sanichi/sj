FactoryBot.define do
  factory :game do
    user
    participants { Game::PARTICIPANTS.sample }
    upto         { Game::UPTO.sample }
  end
end
