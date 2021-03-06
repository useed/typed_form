module TypedForm
  module FormData
    # Question value objects represent the Typeform concept of a question, but
    # expose an interface for querying questions and answers.
    #
    # @attr_reader [Array<Strong>] ids The Typeform IDs for the question. This
    #   is ids instead of id because of the way Typeform represents multiple
    #   choice questions.
    # @attr_reader [Integer] field_id The Typeform Field ID for the question
    # @attr_reader [String] The original text for the question before answers
    #   are extrapolated back into the question.
    # @attr [String] answer The answer of the question.
    # @attr [Text] answer The extrapolated text for the question
    class Question
      attr_reader :ids, :field_id, :original_text
      attr_accessor :answer, :text, :original_answer

      # Creates a new Question value object, which represents any number of
      # questions in a Typeform Form that can be logically represented as a
      # single question. This includes both single question fields and fields
      # like multiple choice, picture choice, etc.
      #
      # @param [Array<Strong>] ids The Typeform IDs for the question. This
      #   is ids instead of id because of the way Typeform represents multiple
      #   choice questions.
      # @param [Integer] field_id The Typeform Field ID for the question
      # @param [String] original_text The original text for the question before
      #   answers are extrapolated back into the question.
      def initialize(ids:, field_id:, original_text:)
        @ids = ids
        @field_id = field_id
        @original_text = original_text
      end

      # Splits into an array based on the id of the question, to
      # determine the Type of object. This information can be queried in order
      # to allow users to handle various types of Typeform data differently.
      def type
        detected_type = ids.map { |id| id.split("_")[0] }.uniq
        return detected_type.first if detected_type.size == 1
        raise StandardError, "Cannot detect type of question ids #{ids}"
      end

      # Creates a new Question with existing data from a previous question.
      #
      # @return [Question] Question with extrapolated text in questions and
      #   with the answer to the question as an attribute.
      def self.with_response_data(question:, text:, answer:, original_answer:)
        question.dup.tap do |new_question|
          new_question.answer = answer
          new_question.original_answer = original_answer
          new_question.text = text
        end.freeze
      end
    end
  end
end
