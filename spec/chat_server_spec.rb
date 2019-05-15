RSpec.describe ChatServer do
  it "has a version number" do
    expect(ChatServer::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
