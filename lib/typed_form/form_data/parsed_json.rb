module TypedForm
  module FormData
    # A small class which wraps functionality for parsing JSON data from the
    # Typeform Data API.
    # @attr_reader [String] JSON string
    class ParsedJson
      extend Forwardable
      attr_reader :json

      # @!method questions
      #   @return [Arendelle] An immutable representation of the Typeform Data
      #     API JSON questions field.
      # @!method responses
      #   @return [Arendelle] An immutable representation of the Typeform Data
      #     API JSON responses field.
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
