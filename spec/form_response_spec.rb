require "spec_helper"

def build_response(jsonfile = "example_form_response", selector = :first)
  parsed = TypedForm::JSONResponseHandler.new(data_api_json(jsonfile))
  TypedForm::FormResponse.new(parsed_questions: parsed.questions,
                              parsed_response: parsed.responses.send(selector))
end

RSpec.describe TypedForm::FormResponse do
  context "multiple choice questions" do
    let(:question_data) do
      Arendelle.new(
        id: "list_s9XJ_choice_V0ry",
        question: "Required: What type of group is your organization?",
        field_id: "45281507"
      )
    end
    let(:response) { build_response("multiple_choice") }

    describe "#question_ids" do
      it "should have the correct question_ids" do
        expected_ids = %w(list_s9XJ_choice_V0ry list_s9XJ_choice_asCn
                          list_s9XJ_choice_aS3W list_s9XJ_other
                          list_45281545_choice_57415657
                          list_45281545_choice_57415658
                          list_45281545_choice_57415659
                          list_45281545_other)
        expect(response.question_ids).to match_array expected_ids
      end
    end

    describe "#questions_and_answers" do
      it "should populate all response with question and answer data" do
        expect(response.questions_and_answers.size).to eq 2
      end
    end

    describe "#question_texts" do
      it "should have provide the right text for the question" do
        expect(response.question_texts).to eq [
          "Required: What type of group is your organization?",
          "Non-Required: What type of group is your organization?"
        ]
      end
    end
  end
end
