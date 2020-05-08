require 'rails_helper'

describe Message do
  let(:game) { create(:game) }

  it "hand" do
    msg = game.messages.create(hand: [1, 2, 3])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"hand\":[1,2,3]}"
  end

  it "disc" do
    msg = game.messages.create(disc: -2)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"disc\":-2}"
  end

  it "pack" do
    msg = game.messages.create(pack: 5)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"pack\":5}"
  end

  it "player" do
    msg = game.messages.create(player: 371)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"player\":371}"
  end

  it "all" do
    msg = game.messages.create(hand: [-2, -1, 0], disc: 12, pack: 9, player: 99481)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"hand\":[-2,-1,0],\"disc\":12,\"pack\":9,\"player\":99481}"

    game.destroy
    expect(Message.count).to eq 0
  end
end
