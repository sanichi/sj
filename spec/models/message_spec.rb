require 'rails_helper'

describe Message do
  let(:game) { create(:game) }

  it "hand" do
    msg = Message.create(game: game, hand: [1, 2, 3])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"hand\":[1,2,3]}"
  end

  it "disc" do
    msg = Message.create(game: game, disc: -2)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"disc\":-2}"
  end

  it "pack" do
    msg = Message.create(game: game, pack: 5)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"pack\":5}"
  end

  it "all" do
    msg = Message.create(game: game, hand: [-2, -1, 0], disc: 12, pack: 9)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"hand\":[-2,-1,0],\"disc\":12,\"pack\":9}"

    game.destroy
    expect(Message.count).to eq 0
  end
end
