module TypedForm
  class FormAnswers
    extend Forwardable

    def_delegators :response, :answers, :metadata, :token
    def_delegators :metadata, :date_submit

    attr_reader :response, :input_questions, :original_questions

    def self.collate(response:, input_questions:, original_questions:)
      new(response: response,
          input_questions: input_questions,
          original_questions: original_questions).questions
    end

    def initialize(response:, input_questions:, original_questions:)
      @response = response
      @input_questions = input_questions
      @original_questions = original_questions
    end

    def questions
      @_questions ||= build_questions
    end

    private

    def build_questions
      input_questions.map do |question|
        Question.with_response_data(
          question: question,
          answer: answers_for(question.ids),
          text: extrapolated_question_text(question)
        )
      end
    end

    def answers_for(ids)
      id_answers = ids.map { |id| find_answer_by_id(id) }.compact
      return if id_answers.size.zero?
      id_answers.join(", ")
    end

    def extrapolated_question_text(question)
      regex = %r(\{\{answer_(\d+)\}\})
      id_match = question.original_text.match(regex)
      return question.original_text unless id_match

      question.original_text.gsub(regex, find_answer_by_field_id(id_match[1]))
    end

    def find_answer_by_field_id(id)
      fields = original_questions.select do |question|
        question.field_id == id.to_i
      end

      answers_found = fields.map { |field| find_answer_by_id(field.id) }.compact
      return find_answer_by_id(fields.first.id) if answers_found.size == 1
      raise ArgumentError, "Cannot find single answer with field ID ##{id}"
    end

    def find_answer_by_id(id)
      answers.instance_variable_get("@#{id}")
    end
  end
end
