require "spec_helper"

RSpec.describe TypedForm::Webhook do
  let(:json) { webhook_json("multiple_choice") }
  let(:webhook) { TypedForm::Webhook.new(json: json) }

  describe "#json" do
    it "should return the original json" do
      expect(webhook.json).to eq json
    end

    it "should be frozen" do
      expect(webhook.json.frozen?).to be_truthy
    end
  end

  describe "#form_token" do
    it "should return the form token" do
      expect(webhook.form_token).to eq "aac0808e3c9c20edef5efc880ef86db0"
    end
  end

  describe "#form_id" do
    it "should return the form id" do
      expect(webhook.form_id).to eq "HEv9qr"
    end
  end
end
