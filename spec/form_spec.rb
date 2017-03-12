require "spec_helper"

def expected_single_form_response
  {
    "Please write your name below." => "Rob",
    "Thanks Rob! What email address would you like to be contacted at?" => "robcole@useed.org",
    "To apply to use our crowdfunding training program, you must be affiliated with Colevester University. Please read and accept the terms below to proceed." => "1",
    "Please indicate which type of Colevester funding account is affiliated with your project." => "Colevester Academic or Department agency account",
    "Are these funds for a research-related activity?" => "0",
    "What type of project is your fundraising intended to support?" => "Engineering, Student Organization",
    "Do you have a deadline for funds to be available?" => "1",
    "When do you need the funds available by?" => "1492214400000",
    "How much money are you looking to raise?" => "4200",
    "Have you participated in a crowdfunding campaign in the past?" => nil,
    "Can you provide a link to one of your previous campaign pages?" => nil,
    "I am applying on behalf of:" => "Student Organization",
    "What is the name of your Student Organization?" => "Chip Uno's Engineering Team",
    "Does Chip Uno's Engineering Team have an advisor (coach, department head, etc)?" => "Yes -- that's me!",
    "What is the email address for the advisor of Chip Uno's Engineering Team?" => nil,
    "What is the name of the advisor of Chip Uno's Engineering Team?" => nil,
    "How many active members are there in Chip Uno's Engineering Team who will help you fundraise?" => "42",
    "Please provide the names and email addresses of those who will be involved in leading this crowdfunding campaign (5-8 people)." => "Echo Dog, echo.dog@example.com",
    "In 1-2 paragraphs, please share what you are seeking to raise money for through crowdfunding. Please be as detailed, yet concise, as possible." => "This is the section where we write a detailed, yet concise, answer about what we're raising funds for.",
    "What is the budget breakdown* for your team's anticipated fundraising goal size?" => "And here we provide an accurate budget breakdown!"
  }
end

RSpec.describe TypedForm::Form do
  describe ".new" do
    it "should build form data from the JSON file" do
      json = data_api_json("single_form_response")
      form = TypedForm::Form.new(json: json)
      expect(form.json).to eq json
    end
  end

  describe "#to_hash" do
    it "should produce the expected Q&A format" do
      json = data_api_json("single_form_response")
      form = TypedForm::Form.new(json: json)
      expect(form.to_hash).to eq expected_single_form_response
    end
  end
end
