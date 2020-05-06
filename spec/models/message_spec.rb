require 'rails_helper'

describe Message do
  let(:player) { create(:player) }

  it "hand" do
    msg = Message.create(player: player, hand: [1, 2, 3])

    expect(Message.count).to eq 1
    expect(msg).to_not be_sent
    expect(msg.json).to eq "{\"hand\":[1,2,3]}"
  end

  it "disc" do
    msg = Message.create(player: player, disc: -2)

    expect(Message.count).to eq 1
    expect(msg).to_not be_sent
    expect(msg.json).to eq "{\"disc\":-2}"
  end

  it "pack" do
    msg = Message.create(player: player, pack: 5)

    expect(Message.count).to eq 1
    expect(msg).to_not be_sent
    expect(msg.json).to eq "{\"pack\":5}"
  end

  it "all" do
    msg = Message.create(player: player, hand: [-2, -1, 0], disc: 12, pack: 9)

    expect(Message.count).to eq 1
    expect(msg).to_not be_sent
    expect(msg.json).to eq "{\"hand\":[-2,-1,0],\"disc\":12,\"pack\":9}"

    player.destroy
    expect(Message.count).to eq 0
  end
end
