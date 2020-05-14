require 'rails_helper'

describe Message do
  let(:game) { create(:game) }

  it "pack" do
    msg = game.send(:add_msg, "pack", 5)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"pack\",\"val\":[5]}"
  end

  it "pack_vis (on)" do
    msg = game.send(:add_msg, "pack_vis", true)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"pack_vis\",\"val\":[1]}"
  end

  it "pack_vis (off)" do
    msg = game.send(:add_msg, "pack_vis", false)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"pack_vis\",\"val\":[0]}"
  end

  it "discard" do
    msg = game.send(:add_msg, "discard", -2)

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"discard\",\"val\":[-2]}"
  end

  it "hand" do
    msg = game.send(:add_msg, "hand", [371, 1, 2, 3])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"hand\",\"val\":[371,1,2,3]}"
  end

  it "reveal" do
    msg = game.send(:add_msg, "reveal", [371, 4])

    expect(Message.count).to eq 1
    expect(msg.json).to eq "{\"key\":\"reveal\",\"val\":[371,4]}"
  end
end
