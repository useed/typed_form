module TypedForm
  # Methods used for handling incoming webhook events with data using the
  # Typeform Webhook JSON schema.
  #
  # @see https://www.typeform.com/help/webhooks/ Typeform Webhook Docs
  #
  # @attr_reader [String] json JSON data from an incoming Typeform Webhook
  class Webhook
    extend Forwardable

    # @!method form_response
    #   @return [Arendelle] An immutable representation of the Webhook JSON
    #     form_response field.
    def_delegators :parsed_json, :form_response

    # @!method form_id
    #   @return [String] The form ID from the webhook submission.
    def_delegators :form_response, :form_id
    attr_reader :json

    # Creates a new webhook object from an incoming Typeform Data stream.
    # @param [String] json JSON Data from a Typeform Webhook
    def initialize(json: json)
      @json = json.freeze
    end

    # Retrieves the Token from the Webhook JSON data.
    #
    # @return [String] Unique token for the form submission.
    def form_token
      form_response.token
    end

    # Retrieves the Form ID from the Webhook JSON data.
    #
    # @return [Integer] Typeform Form ID for the Webhook.
    def form_id
      form_response.form_id
    end

    private

    def parsed_json
      @_parsed_json ||= JSON.parse(json, object_class: Arendelle)
    end
  end
end
