module TypedForm
  class Form
    extend Forwardable
    attr_accessor :json
    def_delegators :parsed_json, :responses
    def_delegators :submission, :questions

    def self.find_form_by(client:, form_id:, token:)
      json = client.find_form_by(form_id: form_id, token: token)
      new(json: json)
    end

    def self.build_form_from(json:)
      new(json: json)
    end

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

    def to_hash
      questions.each_with_object({}) { |q, hash| hash[q.text] = q.answer }
    end

    private

    def parsed_json
      @_parsed_json ||= ParsedJson.new(json: json)
    end

    def response
      responses.first
    end

    private_class_method :new

    def initialize(json: json)
      @json = json
    end
  end
end
