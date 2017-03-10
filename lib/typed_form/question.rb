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
      @_type ||= determine_type
    end

    def type_for_grouped(grouped_questions)
      types = questions.map(&:type)
      return types.first if types.uniq.size == 1
      raise ArgumentError, "Grouped questions do not have matching types"
    end

    def self.with_response_data(question:, text:, answer:)
      question.dup.tap do |new_question|
        new_question.answer = answer
        new_question.text = text
      end
    end

    private

    def determine_type
      detected_type = ids.map { |id| id.split("_")[0] }.uniq
      return detected_type.first if detected_type.size == 1
      raise StandardError, "Cannot detect type of question ids #{ids}"
    end
  end
end
