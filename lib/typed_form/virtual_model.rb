module TypedForm
  # A representation of the Typeform Response Data for a single form response.
  # Dynamically adds methods at initialization time, to provide a simple
  # interface for accessing form response data.
  #
  # ```ruby
  # # this example would require json data with a question of "What is your
  # # "email?" and an answer of "user@example.com"
  #
  # form = TypedForm::Form.build_form_from(json: your_json_source)
  # hash = { "user_email" => "What is your email" }
  # virtual_model = TypedForm::VirtualModel.new(form: form, question_attr: hash)
  # ```
  #
  # VirtualModel has now dynamically matched the user_email attribute to the
  # answer of the question, by finding the question matching the regular
  # expression "What is your email", and then responding with the answer.
  #
  # ```ruby
  # virtual_model.user_email => "user@example.com"
  # ```
  #
  # @attr_reader [Form] form The instance of the form used when referencing
  #   questions and answers in the submission.
  # @attr_reader [Hash] question_attrs Hash mapping attribute names to regular
  #   expressions, expressed as strings.
  #
  #   Format example: To match the answers of "What is your email" to an
  #   attribute of "user_email", the format would look like:
  #
  #   ```ruby
  #   question_attrs = { "user_email" => "What is your email" }
  #   ```
  #
  # @attr_reader [Hash] response_attrs Hash mapping attribute names to a
  #   chain of attributes accessbile from the form response.
  #
  #   Format example: To match the user_agent of the submission, which is under
  #   response["metadata"]["user_agent"], the format would look like:
  #
  #   ```ruby
  #   response_attrs = { "user_agent" => "metadata.user_agent" }
  #   ```
  class VirtualModel
    attr_reader :form, :question_attrs, :response_attrs

    def initialize(form:, question_attrs: nil, response_attrs: nil)
      @form = form

      _define_question_attributes(question_attrs || {})
      _define_response_attributes(response_attrs || {})
    end

    private

    def find_answer_to(text)
      question = form.questions.detect { |q| q.text.match Regexp.new(text) }
      return unless question
      question.answer
    end

    def typecast_response_field(message, response_field)
      response = build_response(message, response_field)
      case response_field
      when /date/ then DateTime.parse(response)
      else response
      end
    end

    def build_response(message, response_field)
      valid_fields = message.singleton_methods.map(&:to_s)

      if valid_fields.include?(response_field)
        message.send(response_field)
      else
        msg = "#{response_field} is not a valid field name for the TypeForm "\
              "response. Valid fields are: #{valid_fields.join(', ')}"
        raise ArgumentError, msg
      end
    end

    def able_to_define?(attr)
      !self.class.method_defined?(attr) &&
        attr.to_s.match(/^[a-z_][a-zA-Z_0-9!?]*$/)
    end

    def _define_question_attributes(question_attrs)
      question_attrs.each do |k, v|
        next unless able_to_define?(k)

        define_singleton_method k do
          find_answer_to(v)
        end
      end
    end

    def response_attribute_value(messages)
      messages.split(".").inject(form.response) do |message, response_field|
        typecast_response_field(message, response_field)
      end
    end

    def _define_response_attributes(response_attrs)
      response_attrs.each do |k, v|
        next unless able_to_define?(k)

        define_singleton_method k do
          response_attribute_value(v)
        end
      end
    end
  end
end
