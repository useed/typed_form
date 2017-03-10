module TypedForm
  class FormResponse
    attr_reader :parsed_questions, :parsed_response

    def initialize(parsed_questions:, parsed_response:)
      @parsed_questions = parsed_questions
      @parsed_response = parsed_response
    end

    def questions_and_answers
      FormAnswers.collate(response: parsed_response,
                          input_questions: questions,
                          original_questions: parsed_questions)
    end

    def questions
      @_questions ||= build_questions
    end

    def question_ids
      questions.flat_map(&:ids)
    end

    def question_texts
      questions.map(&:original_text).uniq
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
        )
      end
    end
  end
end
