module TypedForm
  module FormData
    # Takes an individual parsed Response for a series of questions, and
    # provides an interface for accessing the Question Value Objects.
    #
    # @attr_reader [ParsedJson] parsed_questions A collection of immutable
    # value objects representing Typeform Questions.
    # @attr_reader [ParsedJson] parsed_response An individual response for
    # a Typeform Form.
    class FormSubmission
      attr_reader :parsed_questions, :parsed_response

      # Creates a new Form Submission.
      #
      # @param [ParsedJson] parsed_questions A collection of immutable
      # value objects representing Typeform Questions.
      # @param [ParsedJson] parsed_response An individual response for
      # a Typeform Form.
      def initialize(parsed_questions:, parsed_response:)
        @parsed_questions = parsed_questions
        @parsed_response = parsed_response
      end

      # Builds a full set of Question Value Objects with answer text.
      # @return [Array<Question>]
      def questions
        @_questions ||= Answers.collate(parsed_response: parsed_response,
                                        parsed_questions: parsed_questions,
                                        input_questions: input_questions)
      end

      private

      def question_for_grouped(grouped_questions)
        question_texts = grouped_questions.map(&:question)
        return question_texts.first if question_texts.uniq.size == 1
        raise ArgumentError, "Grouped questions do not have matching text"
      end

      def answerable_questions
        parsed_questions
          .reject { |q| q.id.match /(hidden|legal|statement|group)/ }
          .group_by(&:field_id)
      end

      def input_questions
        @_input_questions ||= answerable_questions.map do |field_id, grouped_q|
          Question.new(
            ids: grouped_q.map(&:id),
            field_id: field_id,
            original_text: question_for_grouped(grouped_q)
          ).freeze
        end
      end
    end
  end
end
