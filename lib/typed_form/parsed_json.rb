module TypedForm
  class ParsedJson
    extend Forwardable
    attr_reader :json

    def_delegators :parsed_json, :questions, :responses

    def initialize(json:)
      @json = json.freeze
    end

    private

    def parsed_json
      @_parsed_json ||= JSON.parse(json, object_class: Arendelle)
    end
  end
end
