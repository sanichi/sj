require 'rails_helper'

describe User do
  let!(:user) { create(:user, admin: false) }

  it "can be destroyed without games or players" do
    expect(user.destroy).to be_truthy
    expect(User.exists?(user.id)).to eq false
  end

  it "can't be destroyed with a game" do
    create(:game, user: user)

    expect(user.destroy).to eq false
    expect(user.errors[:base]).to be_present
    expect(User.exists?(user.id)).to eq true
  end

  it "can't be destroyed with a player" do
    create(:player, user: user)

    expect(user.destroy).to eq false
    expect(user.errors[:base]).to be_present
    expect(User.exists?(user.id)).to eq true
  end
end
