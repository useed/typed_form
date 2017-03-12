module TypedForm
  module FormData
    # A small class which wraps functionality for parsing JSON data from the
    # Typeform Data API.
    class ParsedJson
      extend Forwardable
      attr_reader :json

      # @!method questions
      #   @return [Arendelle] parsed_json["questions"] questions data
      # @!method responses
      #   @return [Arendelle] parsed_json["responses"] response data
      def_delegators :parsed_json, :questions, :responses

      # Creates and freezes JSON data.
      # @param [String] json JSON data matching the Typeform Data API format.
      def initialize(json:)
        @json = json.freeze
      end

      private

      def parsed_json
        @_parsed_json ||= JSON.parse(json, object_class: Arendelle)
      end
    end
  end
end
