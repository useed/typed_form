module TypedForm
  # A representation of the Typeform Form Data for a single
  # form response.
  #
  # @attr_reader [String] json JSON data using Typeform's Data API schema
  class Form
    extend Forwardable
    attr_accessor :json

    # @!method responses
    # @see FormData::ParsedJson#responses
    def_delegators :parsed_json, :responses

    # @!method questions
    # @see FormSubmission#questions
    def_delegators :submission, :questions

    # Creates a new instance of a Form, to allow querying
    def initialize(json:)
      @json = json
    end

    # Uses the Typeform API client to query/find the form based on the form_id
    # and token, then builds a new Form from that JSON request.
    # @param [API::Client] client Typeform API client instance
    # @param [String] form_id Form ID you're querying
    # @param [String] token The token for the response you're retrieving
    # @return [Form] A Form, via JSON fetched from Typeform's API
    def self.find_form_by(client:, form_id:, token:)
      json = client.find_form_by(form_id: form_id, token: token)
      new(json: json)
    end

    # Builds a hash of Questions matched with Answers.
    # @return [Hash] A Hash matching { "Question" => "Answer" } format.
    def to_hash
      questions.each_with_object({}) { |q, hash| hash[q.text] = q.answer }
    end

    private

    def submission
      raise StandardError, "Form expects a single response" if multi_response?
      @_submission ||= FormData::FormSubmission.new(
        parsed_questions: parsed_json.questions,
        parsed_response: responses.first
      )
    end

    def multi_response?
      responses.size > 1
    end

    def parsed_json
      @_parsed_json ||= FormData::ParsedJson.new(json: json)
    end

    def response
      responses.first
    end
  end
end
