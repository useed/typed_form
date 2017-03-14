require "spec_helper"

RSpec.describe TypedForm::Webhook do
  let(:json) { webhook_json("incoming_webhook") }
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
      expect(webhook.form_token).to eq "d1bbc77432d7a605c51a15d47f568dae"
    end
  end

  describe "#form_id" do
    it "should return the form id" do
      expect(webhook.form_id).to eq "DPJEp0"
    end
  end
end
