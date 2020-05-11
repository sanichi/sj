require 'rails_helper'

describe Game do
  let(:user) { create(:user, admin: false) }
  let(:data) { build(:game) }

  let!(:game) { create(:game, user: user) }

  context "admins" do
    before(:each) do
      login user
    end

    it "create game" do
      click_link t("game.new")
      select data.participants.to_s, from: t("game.participants")
      select data.upto.to_s, from: t("game.upto")
      click_button t("save")

      expect(page).to have_title t("game.games")
      expect(Game.count).to eq 2

      g = Game.first
      expect(g.user).to eq user
      expect(g.participants).to eq data.participants
      expect(g.upto).to eq data.upto
    end

    it "delete game" do
      expect(Game.count).to eq 1

      click_link t("delete")

      expect(page).to have_title t("game.games")
      expect(Game.count).to eq 0
    end
  end
end