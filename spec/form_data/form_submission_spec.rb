require "spec_helper"

def build_submission(jsonfile = "example_form_responses", selector = :first)
  parsed = TypedForm::FormData::ParsedJson.new(json: data_api_json(jsonfile))
  TypedForm::FormData::FormSubmission.new(
    parsed_questions: parsed.questions,
    parsed_response: parsed.responses.send(selector)
  )
end

RSpec.describe TypedForm::FormData::FormSubmission do
  context "multiple choice questions" do
    let(:question_data) do
      Arendelle.new(
        id: "list_s9XJ_choice_V0ry",
        question: "Required: What type of group is your organization?",
        field_id: "45281507"
      )
    end
    let(:submission) { build_submission("multiple_choice") }

    describe "#questions" do
      it "should populate the submission with question and answer data" do
        expect(submission.questions.size).to eq 2
      end
    end
  end
end
