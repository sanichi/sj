require 'rails_helper'

describe Message do
  let(:game) { create(:game) }

  it "pack" do
    msg = game.messages.create(pack: 5)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"pack\":5}"
  end

  it "pack_vis" do
    msg = game.messages.create(pack_vis: true)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"pack_vis\":true}"
  end

  it "discard" do
    msg = game.messages.create(discard: -2)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"discard\":-2}"
  end

  it "hand" do
    msg = game.messages.create(hand: [1, 2, 3])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"hand\":[1,2,3]}"
  end

  it "reveal" do
    msg = game.messages.create(reveal: 4)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"reveal\":4}"
  end

  it "player_id" do
    msg = game.messages.create(player_id: 371)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"player_id\":371}"
  end

  it "multiple" do
    msg = game.messages.create(pack: 9, pack_vis: false, discard: 12, hand: [-2, -1, 0], player_id: 99481)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"pack\":9,\"pack_vis\":false,\"discard\":12,\"player_id\":99481,\"hand\":[-2,-1,0]}"

    game.destroy
    expect(Message.count).to eq 0
  end
end
