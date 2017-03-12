module TypedForm
  # A collection of Modules that build value objects around data from the
  # Typeform Data API.
  module FormData
    # A collection class which takes a collection of answers to a form, and
    # associates the questions with answers.
    #
    # @attr_reader [Arendelle] parsed_response An immutable object representing
    #   the submission data from the form.
    # @attr_reader [Arendelle] parsed_questions An immutable object representing
    #   the question data from the form.
    class Answers
      extend Forwardable

      # @!method answers
      #   @return [Arendelle] Parsed Questions from Typeform Data API JSON
      # @!method metadata
      #   @return [Arendelle] Parsed Metadata from Typeform Data API JSON
      # @!method token
      #   @return [String] Token extracted from Typeform Data API JSON
      def_delegators :parsed_response, :answers, :metadata, :token

      # @!method token
      #   @return [String] date form was submitted, in UTC
      def_delegators :metadata, :date_submit

      attr_reader :parsed_response, :input_questions, :parsed_questions

      # Builds a collection of Questions, with text extrapolated to support
      # "piped" questions (i.e. "What is the name of your {{answer_42}}").
      #
      # @return [Array<Question>] Question value objects with extrapolated
      #   text and answers.
      def self.collate(parsed_response:, parsed_questions:, input_questions:)
        new(parsed_response: parsed_response,
            parsed_questions: parsed_questions,
            input_questions: input_questions).questions
      end

      # Iterates through the existing collection of input questions to build a
      # set of question value objects. Memoizes result.
      # @return [Array<Question>]
      def questions
        @_questions ||= input_questions.map do |question|
          Question.with_response_data(
            question: question,
            answer: answers_for(question.ids),
            text: extrapolated_question_text(question)
          )
        end
      end

      private

      private_class_method :new
      def initialize(parsed_response:, input_questions:, parsed_questions:)
        @parsed_response = parsed_response
        @input_questions = input_questions
        @parsed_questions = parsed_questions
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
        fields = parsed_questions.select do |question|
          question.field_id == id.to_i
        end

        answers_found = fields.map { |f| find_answer_by_id(f.id) }.compact
        return find_answer_by_id(fields.first.id) if answers_found.size == 1
        raise ArgumentError, "Cannot find single answer with field ID ##{id}"
      end

      def find_answer_by_id(id)
        answers.instance_variable_get("@#{id}")
      end
    end
  end
end
