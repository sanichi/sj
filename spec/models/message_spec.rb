require 'rails_helper'

describe Message do
  let(:game) { create(:game) }

  it "pack" do
    msg = game.messages.create(key: "pack", val: [5])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"pack\",\"val\":[5]}"
  end

  it "pack_vis" do
    msg = game.messages.create(key: "pack_vis", val: [1])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"pack_vis\",\"val\":[1]}"
  end

  it "discard" do
    msg = game.messages.create(key: "discard", val: [-2])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"discard\",\"val\":[-2]}"
  end

  it "hand" do
    msg = game.messages.create(key: "hand", val: [371, 1, 2, 3])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"hand\",\"val\":[371,1,2,3]}"
  end

  it "reveal" do
    msg = game.messages.create(key: "reveal", val: [371, 4])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"reveal\",\"val\":[371,4]}"
  end
end
