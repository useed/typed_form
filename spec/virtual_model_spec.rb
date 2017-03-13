require "spec_helper"

RSpec.describe TypedForm::VirtualModel do
  let(:json) { data_api_json("single_form_response") }
  let(:form) { TypedForm::Form.new(json: json) }

  def build_model(form:, question_attrs: nil, response_attrs: nil)
    TypedForm::VirtualModel.new(
      form: form,
      question_attrs: question_attrs,
      response_attrs: response_attrs
    )
  end

  describe "attributes built from questions" do
    it "should build the correct questions" do
      question_attrs = { "random_name" => "What type of project" }
      model = build_model(form: form, question_attrs: question_attrs)
      expect(model.random_name).to eq "Engineering, Student Organization"
    end

    context "attribute is not included in definitions" do
      it "should raise a NoMethodError" do
        model = build_model(form: form)
        expect{model.random_name}.to raise_error(NoMethodError)
      end
    end
  end

  describe "attributes built from responses" do
    it "should build the correct responses" do
      response_attrs = { "submitted_at" => "metadata.date_submit" }
      model = build_model(form: form, response_attrs: response_attrs)
      expect(model.submitted_at).to eq "2017-03-09 21:14:26"
    end

    context "attribute is not included in definitions" do
      it "should raise a NoMethodError" do
        model = build_model(form: form)
        expect{model.submitted_at}.to raise_error(NoMethodError)
      end
    end
  end
end
