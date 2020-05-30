require "content_type"

RSpec.describe ContentType do
  context "when Content-Type is no good" do
    it "raises an error" do
      expect { ContentType.new(nil) }.to raise_error(ContentType::Missing)
    end

    it "raises an error" do
      expect { ContentType.new("") }.to raise_error(ContentType::Missing)
    end
  end

  it "only compares type/subtype" do
    accept =  %w{application/xhtml+xml text/html text/markdown}
    expect(
      ContentType.new("text/html; charset=UTF-8").match?(accept)
    ).to be true
  end

  it "puts just the type/subtype into its string format" do
    expect(
      ContentType.new("text/html; charset=UTF-8").to_s
    ).to eq("text/html")
  end

  context "when given a wildcard" do
    it "raises an error because it doesn't support wildcards yet" do
      expect {
        ContentType.new("text/html; charset=UTF-8").match?(%w{image/*})
      }.to raise_error(ContentType::NotImplementedError, /wildcard/)
    end
  end
end
