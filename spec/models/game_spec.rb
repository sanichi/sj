require 'rails_helper'

describe Game do
  let(:game) { create(:game) }
  let(:player) { create(:player, game: game) }

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
    game.messages.create(pack: -2)
    game.messages.create(discard: -1)

    expect(Game.count).to eq 1
    expect(Message.count).to eq 2

    game.destroy

    expect(Game.count).to eq 0
    expect(Message.count).to eq 0
  end
end
