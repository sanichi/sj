require 'rails_helper'

describe Message do
  let(:game) { create(:game) }
  let(:target) { rand(10000) + 1 }

  it "pack" do
    msg = game.add_msg("pack", 5)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"pack\",\"val\":[5]}"
    expect(msg.target).to eq Message::ALL
    expect(msg.only_start).to eq false
  end

  it "state" do
    msg = game.add_msg("state", 1, for: target, only_start: true)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"state\",\"val\":[1]}"
    expect(msg.target).to eq target
    expect(msg.only_start).to eq true
  end

  it "discard" do
    msg = game.add_msg("discard", -2, not: target)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"discard\",\"val\":[-2]}"
    expect(msg.target).to eq -target
  end

  it "hand" do
    msg = game.add_msg("hand", [371, 1, 2, 3])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"hand\",\"val\":[371,1,2,3]}"
    expect(msg.target).to eq Message::ALL
  end

  it "reveal" do
    msg = game.add_msg("reveal", [371, 4], not: target)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"reveal\",\"val\":[371,4]}"
    expect(msg.target).to eq -target
  end
end
