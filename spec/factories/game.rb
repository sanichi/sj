FactoryBot.define do
  factory :game do
    user
    participants { Game::PARTICIPANTS.sample }
    upto         { Game::UPTO.sample }
    variant      { Game::VARIANTS.sample }
    debug        { [true, false].sample }
  end
end
