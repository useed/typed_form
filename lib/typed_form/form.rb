module TypedForm
  # A representation of the Typeform Form Data for a single form response.
  #
  # @attr_reader [String] raw_json Unformatted JSON data from an incoming
  #   Typeform Webhook.
  class Form
    extend Forwardable

    # @!method responses
    # @see FormData::ParsedJson#responses
    def_delegators :parsed_json, :responses

    # @!method questions
    # @see FormSubmission#questions
    def_delegators :submission, :questions

    attr_reader :raw_json

    # Creates a new instance of a Form, to allow querying
    #
    # @param [String] json Typeform Data API JSON input for form.
    def initialize(json:)
      @raw_json = json
    end

    def json
      @_json ||= Util.normalize_spaces(@raw_json)
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

    def response
      raise StandardError, "Form expects a single response" if multi_response?
      responses.first
    end

    private

    def submission
      @_submission ||= FormData::FormSubmission.new(
        parsed_questions: parsed_json.questions,
        parsed_response: response
      )
    end

    def multi_response?
      responses.size > 1
    end

    def parsed_json
      @_parsed_json ||= FormData::ParsedJson.new(json: json)
    end
  end
end
