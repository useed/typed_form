module TypedForm
  class Question
    attr_reader :ids, :field_id, :original_text
    attr_accessor :answer, :text

    def initialize(ids:, field_id:, original_text:)
      @ids = ids
      @field_id = field_id
      @original_text = original_text
    end

    def add_response_data(answer:, text:)
      @answer = answer
      @text = text
    end

    def type
      @_type ||= field_id.split("_")[0]
    end

    def self.with_response_data(question:, text:, answer:)
      question.dup.tap do |new_question|
        new_question.answer = answer
        new_question.text = text
      end
    end
  end
end
