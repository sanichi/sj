require 'rails_helper'

describe Message do
  let(:game) { create(:game) }

  it "pack" do
    msg = game.messages.create(key: "pack", int: 5)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"pack\",\"val\":[5]}"
  end

  it "pack_vis (on)" do
    msg = game.messages.create(key: "pack_vis", bool: true)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"pack_vis\",\"val\":[1]}"
  end

  it "pack_vis (off)" do
    msg = game.messages.create(key: "pack_vis", bool: false)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"pack_vis\",\"val\":[0]}"
  end

  it "discard" do
    msg = game.messages.create(key: "discard", int: -2)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"discard\",\"val\":[-2]}"
  end

  it "hand" do
    msg = game.messages.create(key: "hand", ints: [371, 1, 2, 3])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"hand\",\"val\":[371,1,2,3]}"
  end

  it "reveal" do
    msg = game.messages.create(key: "reveal", ints: [371, 4])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"reveal\",\"val\":[371,4]}"
  end
end
