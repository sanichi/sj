require 'rails_helper'

describe User do
  let!(:admin)  { create(:user, admin: true) }
  let!(:player) { create(:user, admin: false) }
  let(:data)    { build(:user) }

  KINSHI = "not authorized"

  context "guests" do
    it "can login" do
      visit root_path

      expect(page).to have_title t("session.sign_in")
    end

    it "can't see games" do
      visit waiting_games_path

      expect_error(page, KINSHI)
      expect(page).to have_title t("session.sign_in")
    end

    it "can't search games" do
      visit games_path

      expect_error(page, KINSHI)
      expect(page).to have_title t("session.sign_in")
    end

    it "can't list users" do
      expect(page).to_not have_css "a", text: t("user.users")

      visit users_path

      expect_error(page, KINSHI)
      expect(page).to have_title t("session.sign_in")
    end

    it "can't create users" do
      expect(page).to_not have_css "a", text: t("user.new")

      visit new_user_path

      expect_error(page, KINSHI)
      expect(page).to have_title t("session.sign_in")
    end
  end

  context "players" do
    before(:each) do
      login player
    end

    it "can play" do
      expect(page).to have_title t("game.games")
    end

    it "can log out" do
      click_link t("session.sign_out")

      expect(page).to have_title t("session.sign_in")
    end

    it "can't search games" do
      visit games_path

      expect_error(page, KINSHI)
      expect(page).to have_title t("game.games")
    end

    it "can't list users" do
      expect(page).to_not have_css "a", text: t("user.users")

      visit users_path

      expect_error(page, KINSHI)
      expect(page).to have_title t("game.games")
    end

    it "can't create users" do
      expect(page).to_not have_css "a", text: t("user.new")

      visit new_user_path

      expect_error(page, KINSHI)
      expect(page).to have_title t("game.games")
    end
  end

  context "admins" do
    before(:each) do
      login admin
      click_link t("user.users")
    end

    it "user counts" do
      expect(page).to have_title t("user.users")
      expect(User.where(admin: false).count).to eq 1
      expect(User.where(admin: true).count).to eq 1
    end

    it "create user" do
      click_link t("user.new")
      fill_in t("user.handle"), with: data.handle
      fill_in t("user.password"), with: data.password
      fill_in t("user.name.first"), with: data.first_name
      fill_in t("user.name.last"), with: data.last_name
      click_button t("save")

      expect(page).to have_title data.handle
      expect(User.where(admin: false).count).to eq 2
      u = User.find_by(handle: data.handle)
      expect(u.password).to be_nil
      expect(u.password_digest).to be_present
      expect(u.first_name).to eq data.first_name
      expect(u.last_name).to eq data.last_name
      expect(u.admin).to eq false

      click_link t("session.sign_out")

      expect(page).to have_title t("session.sign_in")

      fill_in t("user.handle"), with: u.handle
      fill_in t("user.password"), with: data.password
      click_button t("session.sign_in")

      expect(page).to have_title t("game.games")
    end

    it "edit user" do
      click_link player.handle_extra
      click_link t("edit")
      fill_in t("user.handle"), with: data.handle
      click_button t("save")

      expect(page).to have_title data.handle
      expect(User.where(admin: false, handle: data.handle).count).to eq 1
    end

    it "delete user" do
      click_link player.handle_extra
      click_link t("edit")
      click_link t("delete")

      expect(page).to have_title t("user.users")
      expect(User.where(admin: false).count).to eq 0
      expect(User.where(admin: true).count).to eq 1
    end
  end
end
