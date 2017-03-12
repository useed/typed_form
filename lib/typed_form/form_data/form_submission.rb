module TypedForm
  module FormData
    # Takes an individual parsed response for a series of questions, and
    # provides an interface for accessing the Question value objects.
    #
    # @attr_reader [Arendelle] parsed_questions Parsed Questions from JSON
    # @attr_reader [Arendelle] parsed_response Parsed Answers from JSON
    class FormSubmission
      attr_reader :parsed_questions, :parsed_response

      # Creates a new Form Submission.
      #
      # @param [Arendelle] parsed_questions Parsed Questions from JSON
      # @param [Arendelle] parsed_response Parsed Answers from JSON
      def initialize(parsed_questions:, parsed_response:)
        @parsed_questions = parsed_questions
        @parsed_response = parsed_response
      end

      # Builds a full set of Question value objects with answer text.
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
          .reject { |q| q.id.match(/(hidden|legal|statement|group)/) }
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
