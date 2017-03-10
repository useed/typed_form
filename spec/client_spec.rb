require "spec_helper"

def stub_typeform_requests
  stub_request(:get, /api\.typeform\.com/)
    .to_return(body: data_api_json("single_form_response"))
end

RSpec.describe TypedForm::Client do
  describe "forming API requests" do
    before :each do
      stub_typeform_requests
    end

    describe "#find_form_by" do
      it "should fetch form data from the API, filtering by the token" do
        api_key = "api_key"
        form_id = "typeform_form_id"
        token = "form_token"
        client = TypedForm::Client.new(api_key: api_key)
        client.find_form_by(form_id: form_id, token: token)

        api_url = "https://api.typeform.com/v1/form/typeform_form_id"
        expect(WebMock)
          .to have_requested(:get, api_url)
          .with(query: { "key" => api_key, "token" => token })
      end
    end
  end
end
