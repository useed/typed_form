require "spec_helper"

def expected_single_form_response
  {
    "Please write your name below."=>"Rob Cole",
    "Thanks Rob Cole! What email address would you like to be contacted at?"=>"robcole@example.com",
    "To apply to use our crowdfunding training program, you must be affiliated with Colevester University. Please read and accept the terms below to proceed."=>"1",
    "Please indicate which type of Colevester funding account is affiliated with your project."=>"Colevester Student Government club account",
    "Are these funds for a research-related activity?"=>"1",
    "What type of project is your fundraising intended to support?"=>"Engineering, Student Organization",
    "Do you have a deadline for funds to be available?"=>"1",
    "When do you need the funds available by?"=>Time.at(1491091200).utc.to_date,
    "How much money are you looking to raise?"=>4200,
    "Have you participated in a crowdfunding campaign in the past?"=>"Yes, I'm a returning USEED fundraiser.",
    "Can you provide a link to one of your previous campaign pages?"=>"https://useed.net/give/previous_campaign",
    "I am applying on behalf of:"=>"Program or Academic Unit",
    "What is the name of your Program or Academic Unit?"=>"Engineering for the Common Good",
    "Does Engineering for the Common Good have an advisor (coach, department head, etc)?"=>"Yes",
    "What is the email address for the advisor of Engineering for the Common Good?"=>"advisor_example@example.com",
    "What is the name of the advisor of Engineering for the Common Good?"=>"Example Advisor Name",
    "How many active members are there in Engineering for the Common Good who will help you fundraise?"=>42,
    "Please provide the names and email addresses of those who will be involved in leading this crowdfunding campaign (5-8 people)."=>"First Leader, first.leader@example.com\nSecond Leader, second.leader@example.com\nThird Leader, third.leader@example.com",
    "In 1-2 paragraphs, please share what you are seeking to raise money for through crowdfunding. Please be as detailed, yet concise, as possible."=>"This would normally be multiple paragraphs.\n\nI guess it is this time, too. This is an explanation of what we're raising money for, with a full accounting for what purpose the money will fill for us.",
    "What is the budget breakdown* for your team's anticipated fundraising goal size?"=>"This budget breakdown will be more detailed, and will include exactly where each portion of our funds is going."
  }
end

RSpec.describe TypedForm::Form do
  describe "#json" do
    it "should build form data from the JSON file" do
      json = data_api_json("single_form_response")
      form = TypedForm::Form.new(json: json)
      expect(form.json).to eq json.gsub("\\u00a0", " ")
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
