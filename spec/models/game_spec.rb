require 'rails_helper'

describe Game do
  let(:game) { create(:game) }
  let(:player) { create(:player, game: game) }

  context "dealing" do
    it "start pack" do
      expect(game.total_remaining).to eq 150
    end

    it "deal one" do
      card = game.card
      expect(card).to be_between(-2, 12).inclusive
      expect(game.total_remaining).to eq 149
    end

    it "deal 12" do
      cards = game.cards(12)
      cards.each do |card|
        expect(card).to be_between(-2, 12).inclusive
      end
      expect(game.total_remaining).to eq 138
    end

    it "deal all" do
      cards = game.cards(150)
      cards.each do |card|
        expect(card).to be_between(-2, 12).inclusive
      end
      expect(game.total_remaining).to eq 0
      expect(game.card).to eq 0
    end

    it "destroy" do
      game.send(:add_msg, "pack", -2)
      game.send(:add_msg, "discard", -1)

      expect(Game.count).to eq 1
      expect(Message.count).to eq 2

      game.destroy

      expect(Game.count).to eq 0
      expect(Message.count).to eq 0
    end
  end

  context "messaging" do
    let(:target) { rand(10000) + 1 }
    let(:other) { target + 1}

    before(:each) do
      game.add_msg("test", 1)
      game.add_msg("test", 2, for: target)
      game.add_msg("test", 3, not: target)
      game.add_msg("test", 4, only_start: true)
      game.add_msg("test", 5, only_start: true, for: target)
      game.add_msg("test", 6, only_start: true, not: target)
    end

    it "at start for target" do
      messages = game.get_messages(target, 0)
      expect(messages.pluck(:json).join("|")).to eq "1|2|3|4|5|6"
    end

    it "at start for non-target" do
      messages = game.get_messages(other, 0)
      expect(messages.pluck(:json).join("|")).to eq "1|2|3|4|5|6"
    end

    it "after start for target" do
      messages = game.get_messages(target, -1)
      expect(messages.pluck(:json).join("|")).to eq "1|2"
    end

    it "after start for non-target" do
      messages = game.get_messages(other, -1)
      expect(messages.pluck(:json).join("|")).to eq "1|3"
    end
  end
end
