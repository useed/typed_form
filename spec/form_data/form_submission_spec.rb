require "spec_helper"

def build_submission(jsonfile = "example_form_responses", selector = :first)
  parsed = TypedForm::ParsedJson.new(json: data_api_json(jsonfile))
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

    describe "#question_ids" do
      it "should have the correct question_ids" do
        expected_ids = %w(list_s9XJ_choice_V0ry list_s9XJ_choice_asCn
                          list_s9XJ_choice_aS3W list_s9XJ_other
                          list_45281545_choice_57415657
                          list_45281545_choice_57415658
                          list_45281545_choice_57415659
                          list_45281545_other)
        expect(submission.question_ids).to match_array expected_ids
      end
    end

    describe "#questions" do
      it "should populate the submission with question and answer data" do
        expect(submission.questions.size).to eq 2
      end
    end

    describe "#question_texts" do
      it "should have provide the right text for the question" do
        expect(submission.question_texts).to eq [
          "Required: What type of group is your organization?",
          "Non-Required: What type of group is your organization?"
        ]
      end
    end
  end
end
