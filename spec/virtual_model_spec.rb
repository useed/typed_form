require "spec_helper"

def question_attrs
  {
    "name" => "write your name",
    "email" => "What email address",
    "terms" => "the terms below",
    "funding_account_type" => "type of Colevester funding account",
    "research_related" => "Are these funds for a research",
    "project_type" => "What type of project",
    "has_deadline" => "Do you have a deadline for funds to be available",
    "need_funds_by" => "When do you need the funds available by",
    "goal_amount" => "How much money",
    "participated_in_crowdfunding" => "participated in a crowdfunding",
    "prev_campaign_link" => "Can you provide a link to one of your previous",
    "org_type" => "I am applying on behalf of",
    "org_name" => "What is the name of your .+",
    "has_advisor" => "Does .+ have an advisor",
    "advisor_email" => "What is the email address for the advisor",
    "advisor_name" => "What is the name of the advisor",
    "active_members" => "How many active members",
    "leader_contacts" => "provide the names and email addresses .+ leading",
    "cause_text" => "seeking to raise money for",
    "budget" => "What is the budget breakdown"
  }
end

def expected_question_attributes
  leaders = "First Leader, first.leader@example.com\n"\
            "Second Leader, second.leader@example.com\n"\
            "Third Leader, third.leader@example.com"
  long_answer_1 = "This would normally be multiple paragraphs.\n\nI guess it "\
                  "is this time, too. This is an explanation of what we're "\
                  "raising money for, with a full accounting for what purpose "\
                  "the money will fill for us."
  long_answer_2 = "This budget breakdown will be more detailed, and will "\
                  "include exactly where each portion of our funds is going."

  ["Rob Cole", "robcole@example.com", true,
   "Colevester Student Government club account", true,
   "Engineering, Student Organization", true,
   Time.at(1491091200).utc.to_date,
   4200, "Yes, I'm a returning USEED fundraiser.",
   "https://useed.net/give/previous_campaign", "Program or Academic Unit",
   "Engineering for the Common Good", "Yes", "advisor_example@example.com",
   "Example Advisor Name", 42,
   leaders, long_answer_1, long_answer_2]
end

def response_attrs
  {
    "referer" => "metadata.referer",
    "submitted_at" => "metadata.date_submit",
    "token" => "token"
  }
end

def build_model(form:, question_attrs: nil, response_attrs: nil)
  TypedForm::VirtualModel.new(
    form: form,
    question_attrs: question_attrs,
    response_attrs: response_attrs
  )
end

RSpec.describe TypedForm::VirtualModel do
  let(:json) { data_api_json("single_form_response") }
  let(:form) { TypedForm::Form.new(json: json) }

  context "when a date field is not submitted" do
    it "should respond with nil" do
      date_json = data_api_json("single_form_optional_date")
      date_form = TypedForm::Form.new(json: date_json)
      dateq = { "need_funds_by" => "When do you need the funds available by?" }
      model = build_model(form: date_form, question_attrs: dateq)
      expect(model.need_funds_by).to be_nil
    end
  end

  describe "attributes built from questions" do
    question_attrs.each_with_index do |(attr, _), i|
      it "should build the correct #{attr}" do
        model = build_model(form: form, question_attrs: question_attrs)
        expect(model.send(attr)).to eq expected_question_attributes[i]
      end
    end

    context "attribute is not included in definitions" do
      it "should raise a NoMethodError" do
        model = build_model(form: form)
        expect{model.random_name}.to raise_error(NoMethodError)
      end
    end
  end

  describe "attributes built from responses" do
    it "should have a submitted_at" do
      model = build_model(form: form, response_attrs: response_attrs)
      expect(model.submitted_at).to eq DateTime.parse("2017-03-13 23:42:17")
    end

    it "should have a referer" do
      model = build_model(form: form, response_attrs: response_attrs)
      expect(model.referer).to eq "https://devteam4.typeform.com/to/DPJEp0"
    end

    it "should have a token" do
      model = build_model(form: form, response_attrs: response_attrs)
      expect(model.token).to eq "d1bbc77432d7a605c51a15d47f568dae"
    end

    context "attribute is not included in definitions" do
      it "should raise a NoMethodError" do
        model = build_model(form: form)
        expect{model.submitted_at}.to raise_error(NoMethodError)
      end
    end

    context "attribute is incorrectly referenced" do
      it "should raise a ArgumentError" do
        submitted_attr = { "submitted_at" => "metadata.date_submitted" }
        model = build_model(form: form, response_attrs: submitted_attr)
        expect{model.submitted_at}
          .to raise_error(ArgumentError, /date_submitted is not a valid/)
      end
    end
  end
end
