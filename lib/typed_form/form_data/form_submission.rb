module TypedForm
  module FormData
    class FormSubmission
      attr_reader :parsed_questions, :parsed_response

      def initialize(parsed_questions:, parsed_response:)
        @parsed_questions = parsed_questions
        @parsed_response = parsed_response
      end

      def questions
        Answers.collate(response: parsed_response,
                        input_questions: original_questions,
                        original_questions: parsed_questions)
      end

      def original_questions
        @original_questions ||= build_questions
      end

      def question_ids
        original_questions.flat_map(&:ids)
      end

      def question_texts
        original_questions.map(&:original_text).uniq
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

      def build_questions
        answerable_questions.map do |field_id, grouped_questions|
          Question.new(
            ids: grouped_questions.map(&:id),
            field_id: field_id,
            original_text: question_for_grouped(grouped_questions)
          ).freeze
        end
      end
    end
  end
end
